import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import '../models/expiry_status.dart';
import '../utils/expiry_calculation.dart';
import '../constants/app_constants.dart';

/// SQLite database helper for ExpiryAlert.
/// Handles database creation, migrations, CRUD operations, and transactions.
///
/// Follows the offline-first principle: local SQLite is the source of truth.
/// Supabase sync operates on top of this local database.
class DatabaseHelper {
  DatabaseHelper._();

  /// Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  /// Internal factory for setup
  DatabaseHelper._internal();

  /// Database reference
  late final Database _database;

  /// Get database path based on platform
  String get _dbPath {
    final path = join(
      await getDatabasesPath(),
      AppConstants.databaseName,
    );
    return path;
  }

  /// Open the database and initialize tables
  Future<Database> get database async => _database..reload();

  /// Initialize the database once
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      _dbPath,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables on first database initialization
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        brand TEXT,
        barcode TEXT,
        expiryDate TEXT NOT NULL,
        purchaseDate TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        unit TEXT NOT NULL DEFAULT 'pcs',
        notes TEXT,
        imagePath TEXT,
        reminderPreferences TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        deletedAt TEXT,
        syncStatus TEXT NOT NULL DEFAULT 'local'
      )
    ''');

    /// Indexes for common query patterns
    await db.execute('''
      CREATE INDEX idx_products_expiryDate ON products(expiryDate)
    ''');

    await db.execute('''
      CREATE INDEX idx_products_category ON products(category)
    ''');

    await db.execute('''
      CREATE INDEX idx_products_barcode ON products(barcode)
    ''');

    await db.execute('''
      CREATE INDEX idx_products_syncStatus ON products(syncStatus)
    ''');

    await db.execute('''
      CREATE INDEX idx_products_deletedAt ON products(deletedAt)
    ''');

    await db.execute('''
      CREATE INDEX idx_products_createdAt ON products(createdAt)
    ''');
  /// Upgrade database schema when version changes
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add migration for version 2
      await db.execute('''
        ALTER TABLE products ADD COLUMN syncStatus TEXT NOT NULL DEFAULT 'local'
      ''');
    }

    if (oldVersion < 3) {
      // Add migration for version 3
      await db.execute('''
        ALTER TABLE products ADD COLUMN updatedAt TEXT NOT NULL
      ''');
    }

    if (oldVersion < 4) {
      // Add migration for version 4 - full text search index
      await db.execute('''
        CREATE VIRTUAL TABLE products_search using fts5(name, category, notes, content='products', content_rowid=rowid)
      ''');
    }

    if (oldVersion < 5) {
      // Add migration for version 5 - reminder preferences column
      await db.execute('''
        ALTER TABLE products ADD COLUMN reminderPreferences TEXT
      ''');
    }
  }

  /// Initialize the database lazily on first access
  Future<Database> ensureDatabaseOpened() async {
    if (_database == null) {
      await _initDatabase();
    }
    return _database;
  }

  /// --- Product CRUD Operations ---

  /// Insert a new product into the database.
  /// Returns the ID of the inserted product.
  Future<int> insertProduct(Product product) async {
    final db = await database;

    final now = DateTime.utc.now().toIso8601String();

    final map = product.toMap()..addEntries({
      'id': product.id,
      'createdAt': now,
      'updatedAt': now,
      'syncStatus': 'local',
    }.entries);

    final result = await db.insert('products', map,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  /// Insert multiple products in a transaction (for batch operations)
  Future<int> insertProducts(List<Product> products) async {
    final db = await database;
    final now = DateTime.utc.now().toIso8601String();

    final maps = products.map((product) {
      final base = product.toMap();
      base['id'] = product.id;
      base['createdAt'] = now;
      base['updatedAt'] = now;
      base['syncStatus'] = 'local';
      return base;
    }).toList();

    return await db.transaction((txn) async {
      final results = <int>[];
      for (final map in maps) {
        final result = await txn.insert('products', map,
            conflictAlgorithm: ConflictAlgorithm.replace);
        results.add(result);
      }
      return results.length;
    });
  }

  /// Query all products, optionally filtered by category or sync status
  Future<List<Product>> queryProducts({
    String? category,
    String? syncStatus,
    String? searchQuery,
  }) async {
    final db = await database;

    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (category != null && category.isNotEmpty) {
      whereClauses.add('category = ?');
      whereArgs.add(category);
    }

    if (syncStatus != null && syncStatus.isNotEmpty) {
      whereClauses.add('syncStatus = ?');
      whereArgs.add(syncStatus);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClauses.add(
        '(name LIKE ? OR barcode LIKE ? OR notes LIKE ?)',
      );
      final searchPattern = '%$searchQuery%';
      whereArgs.addAll([searchPattern, searchPattern, searchPattern]);
    }

    final whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'expiryDate ASC',
    );

    return maps.map((json) => Product.fromMap(json)).toList();
  }

  /// Query products grouped by expiry status
  Future<Map<String, List<Product>>> queryProductsByStatus() async {
    final db = await database;

    // Get all products and group them by expiry status
    final List<Map<String, dynamic>> maps = await db.query('products', orderBy: 'expiryDate ASC');

    final products = maps.map((json) => Product.fromMap(json)).toList();

    return {
      'safe': getSafeProductsFromList(products),
      'expiringSoon': getExpiringSoonFromList(products),
      'expiresToday': getExpiresTodayFromList(products),
      'expired': getExpiredProductsFromList(products),
    };
  }

  /// Get safe products (more than 7 days remaining)
  List<Product> getSafeProductsFromList(List<Product> products) {
    return products.where((product) {
      final result = ExpiryCalculationEngine.calculateExpiryStatus(
        purchaseDate: product.purchaseDate,
        expiryDate: product.expiryDate,
      );
      return result.daysRemaining >= AppConstants.expiringSoonThresholdDays;
    }).toList();
  }

  /// Get expiring soon products (1-7 days remaining)
  List<Product> getExpiringSoonFromList(List<Product> products) {
    return products.where((product) {
      final result = ExpiryCalculationEngine.calculateExpiryStatus(
        purchaseDate: product.purchaseDate,
        expiryDate: product.expiryDate,
      );
      return result.daysRemaining > 0 &&
          result.daysRemaining <= AppConstants.expiringSoonThresholdDays;
    }).toList();
  }

  /// Get expires today products (0 days remaining)
  List<Product> getExpiresTodayFromList(List<Product> products) {
    return products.where((product) {
      final result = ExpiryCalculationEngine.calculateExpiryStatus(
        purchaseDate: product.purchaseDate,
        expiryDate: product.expiryDate,
      );
      return result.daysRemaining == 0;
    }).toList();
  }

  /// Get expired products (negative days remaining)
  List<Product> getExpiredProductsFromList(List<Product> products) {
    return products.where((product) {
      final result = ExpiryCalculationEngine.calculateExpiryStatus(
        purchaseDate: product.purchaseDate,
        expiryDate: product.expiryDate,
      );
      return result.daysRemaining < 0;
    }).toList();
  }

  /// Get a single product by ID
  Future<Product?> queryProductById(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Product.fromMap(maps.first);
  }

  /// Update an existing product
  Future<int> updateProduct(Product product) async {
    final db = await database;

    final now = DateTime.utc.now().toIso8601String();

    return await db.update(
      'products',
      product.toMap()..update('updatedAt', now),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  /// Delete a product (soft delete - mark as deleted)
  Future<int> deleteProduct(String id) async {
    final db = await database;

    final now = DateTime.utc.now().toIso8601String();

    return await db.update(
      'products',
      {'deletedAt': now, 'syncStatus': 'deleted'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Hard delete a product (permanent removal)
  Future<int> hardDeleteProduct(String id) async {
    final db = await database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Check if a product exists
  Future<bool> productExists(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty;
  }

  /// --- Synchronization Operations ---

  /// Mark product as synced
  Future<void> markAsSynced(String id) async {
    final db = await database;

    await db.update(
      'products',
      {'syncStatus': 'synced', 'updatedAt': DateTime.utc.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Mark product as pending sync
  Future<void> markAsPending(String id) async {
    final db = await database;

    await db.update(
      'products',
      {'syncStatus': 'pending'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get products needing sync (local or pending)
  Future<List<Product>> getProductsNeedingSync() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'syncStatus IN (?, ?)',
      whereArgs: ['local', 'pending'],
      orderBy: 'createdAt ASC',
    );

    return maps.map((json) => Product.fromMap(json)).toList();
  }

  /// Get count of products by sync status
  Future<Map<String, int>?> getProductCountsBySyncStatus() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT syncStatus, COUNT(*) as count
      FROM products
      GROUP BY syncStatus
    ''');

    final map = <String, int>{};
    for (final row in result) {
      map[row['syncStatus']] = row['count'] as int;
    }

    return map.isNotEmpty ? map : null;
  }

  /// --- Database Maintenance ---

  /// Close the database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  /// Vacuum the database to reclaim space
  Future<void> vacuum() async {
    final db = await database;
    await db.execute('VACUUM');
  }

  /// Get database file size
  Future<int> getDatabaseSize() async {
    final db = await database;
    final path = db.path;
    final size = await File(path).length();
    return size;
  }
}

/// Factory for dependency injection
extension DatabaseHelperExtension on DatabaseHelper {
  /// Get a product by ID (convenience method)
  Product? getProduct(String id) => queryProductById(id);

  /// Get all products as a list (convenience method)
  Future<List<Product>> getAllProducts() async {
    return await queryProducts();
  }
}