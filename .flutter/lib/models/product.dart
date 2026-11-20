import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../utils/expiry_calculation.dart';
import '../constants/app_constants.dart';

/// UUID generator for product IDs
final _uuid = Uuid();

/// Product model representing a single item in the expiry alert system.
/// This is the central data model used across all layers:
/// - UI (presentation)
/// - Database (SQLite persistence)
/// - Repository (data source abstraction)
/// - API (Supabase sync)
class Product {
  /// Unique identifier (UUID)
  final String id;

  /// Product name (e.g., "Greek Yogurt 500g")
  final String name;

  /// Product category (from the design system categories)
  final String category;

  /// Product brand (optional)
  final String? brand;

  /// Barcode / GTIN (optional)
  final String? barcode;

  /// Expiry date in YYYY-MM-DD format (date-only, no time component)
  final String expiryDate;

  /// Purchase date in YYYY-MM-DD format (date-only)
  final String purchaseDate;

  /// Quantity of items
  final int quantity;

  /// Unit of measurement (pcs, bottles, packs, boxes, kg, g, ml, L)
  final String unit;

  /// Additional notes about storage, usage, etc. (optional)
  final String? notes;

  /// Path to product image (optional, stored locally or in cloud)
  final String? imagePath;

  /// Reminder preferences as JSON string
  /// Format: {"cadence": [7, 3, 1], "customDates": [timestamp, ...]}
  final String? reminderPreferences;

  /// Timestamp when the product was created (ISO 8601)
  final DateTime createdAt;

  /// Timestamp when the product was last updated (ISO 8601)
  final DateTime updatedAt;

  /// Timestamp when the product was soft-deleted (ISO 8601, null if not deleted)
  final DateTime? deletedAt;

  /// Synchronization status: 'local', 'synced', 'pending', 'error'
  final String syncStatus;

  /// Creates a [Product] with all fields.
  /// All date-only values are stored in YYYY-MM-DD format.
  Product({
    String? id,
    required this.name,
    required this.category,
    this.brand,
    this.barcode,
    required this.expiryDate,
    required this.purchaseDate,
    this.quantity = 1,
    this.unit = 'pcs',
    this.notes,
    this.imagePath,
    this.reminderPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    String? syncStatus,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.utc.now(),
        updatedAt = updatedAt ?? DateTime.utc.now(),
        syncStatus = syncStatus ?? 'local';

  /// Creates a [Product] from a [Map] as returned by SQLite.
  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'] as String?,
        name: map['name'] as String? ?? '',
        category: map['category'] as String? ?? '',
        brand: map['brand'] as String?,
        barcode: map['barcode'] as String?,
        expiryDate: map['expiryDate'] as String? ?? '',
        purchaseDate: map['purchaseDate'] as String? ?? '',
        quantity: (map['quantity'] as num?).toInt() ?? 1,
        unit: map['unit'] as String? ?? 'pcs',
        notes: map['notes'] as String?,
        imagePath: map['imagePath'] as String?,
        reminderPreferences: map['reminderPreferences'] as String?,
        createdAt: (map['createdAt'] as dynamic) is int
            ? DateTime.utc.fromMillisecondsSinceEpoch(
                (map['createdAt'] as int).toInt(),
              )
            : (map['createdAt'] as dynamic) is String
                ? DateTime.parse(map['createdAt'] as String)
                : DateTime.utc.now(),
        updatedAt: (map['updatedAt'] as dynamic) is int
            ? DateTime.utc.fromMillisecondsSinceEpoch(
                (map['updatedAt'] as int).toInt(),
              )
            : (map['updatedAt'] as dynamic) is String
                ? DateTime.parse(map['updatedAt'] as String)
                : DateTime.utc.now(),
        deletedAt:
            (map['deletedAt'] as dynamic) is int
                ? DateTime.utc.fromMillisecondsSinceEpoch(
                    (map['deletedAt'] as int).toInt(),
                  )
                : map['deletedAt'] as DateTime?,
        syncStatus: map['syncStatus'] as String? ?? 'local',
      );

  /// Converts this [Product] to a [Map] for SQLite storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'brand': brand,
      'barcode': barcode,
      'expiryDate': expiryDate,
      'purchaseDate': purchaseDate,
      'quantity': quantity,
      'unit': unit,
      'notes': notes,
      'imagePath': imagePath,
      'reminderPreferences': reminderPreferences,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncStatus': syncStatus,
    };
  }

  /// Returns the expiry status for this product.
  ExpiryStatusResult getExpiryStatus() {
    return ExpiryCalculationEngine.calculateExpiryStatus(
      purchaseDate: purchaseDate,
      expiryDate: expiryDate,
    );
  }

  /// Gets the expiry status as a string label.
  String getExpiryLabel() {
    return getExpiryStatus().expiryLabel;
  }

  /// Gets the status color for this product's expiry.
  Color getStatusColor() {
    return getExpiryStatus().statusColor;
  }

  /// Gets the number of days remaining until expiry.
  int getDaysRemaining() {
    return getExpiryStatus().daysRemaining;
  }

  /// Checks if the product is expired.
  bool get isExpired => getExpiryStatus().isNegative;

  /// Checks if the product is safe (more than 7 days remaining).
  bool get isSafe => getExpiryStatus().status == ExpiryStatus.SAFE;

  /// Checks if the product is expiring soon (1-7 days remaining).
  bool get isExpiringSoon => getExpiryStatus().status == ExpiryStatus.EXPIRING_SOON;

  /// Checks if the product expires today (0 days remaining).
  bool get expiresToday => getExpiryStatus().status == ExpiryStatus.EXPIRES_TODAY;

  /// Checks if the product purchase date is after the expiry date.
  bool get isExpiryBeforePurchase => ExpiryCalculationEngine.isExpiryBeforePurchase(
        purchaseDate: purchaseDate,
        expiryDate: expiryDate,
      );

  /// Converts the product to a JSON map for Supabase/cloud serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'brand': brand,
      'barcode': barcode,
      'expiryDate': expiryDate,
      'purchaseDate': purchaseDate,
      'quantity': quantity,
      'unit': unit,
      'notes': notes,
      'imagePath': imagePath,
      'reminderPreferences': reminderPreferences,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'syncStatus': syncStatus,
    };
  }

  /// Creates a [Product] from a JSON map (Supabase deserialization).
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? '',
        brand: json['brand'] as String?,
        barcode: json['barcode'] as String?,
        expiryDate: json['expiryDate'] as String? ?? '',
        purchaseDate: json['purchaseDate'] as String? ?? '',
        quantity: (json['quantity'] as num?).toInt() ?? 1,
        unit: json['unit'] as String? ?? 'pcs',
        notes: json['notes'] as String?,
        imagePath: json['imagePath'] as String?,
        reminderPreferences: json['reminderPreferences'] as String?,
        createdAt: json['createdAt'] is String
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.utc.now(),
        updatedAt: json['updatedAt'] is String
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.utc.now(),
        deletedAt:
            json['deletedAt'] is String
                ? DateTime.parse(json['deletedAt'] as String)
                : json['deletedAt'] is int
                    ? DateTime.utc.fromMillisecondsSinceEpoch(
                        json['deletedAt'] as int,
                      )
                    : null,
        syncStatus: json['syncStatus'] as String? ?? 'local',
      );

  /// Creates a copy of this product with modified fields.
  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? brand,
    String? barcode,
    String? expiryDate,
    String? purchaseDate,
    int? quantity,
    String? unit,
    String? notes,
    String? imagePath,
    String? reminderPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? syncStatus,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      barcode: barcode ?? this.barcode,
      expiryDate: expiryDate ?? this.expiryDate,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      reminderPreferences: reminderPreferences ?? this.reminderPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// String representation for debugging.
  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category, '
        'expiry: $expiryDate, purchase: $purchaseDate, qty: $quantity)';
  }

  /// Equality comparison based on ID.
  @override
  bool operator ==(Object other) {
    identical(this, other) ||
        other is Product &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}