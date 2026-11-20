import 'package:go_router/go_router.dart';
import 'package:expiry_alert/features/home/home.dart';
import 'features/products/products.dart';
import 'features/add_product/add_product.dart';
import 'features/settings/settings.dart';
import 'features/onboarding/onboarding.dart';
import 'features/authentication/auth.dart';

/// GoRouter configuration for ExpiryAlert.
/// Handles navigation, deep links, and Android back navigation.
final GoRouter router = GoRouter(
  initialRoute: '/home',
  routes: <String, GoRoute>[
    /// Splash/Welcome route
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('ExpiryAlert'),
        ),
      ),
    ),

    /// Onboarding flow for new users
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    /// Authentication routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(authType: AuthType.login),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const AuthScreen(authType: AuthType.register),
    ),

    /// Main home dashboard
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeDashboard(),
      routes: [
        /// Product details deep link
        GoRoute(
          path: 'product-details/:id',
          builder: (context, state) {
            final productId = state.pathParameters['id'] ?? '';
            return ProductDetailsScreen(productId: productId);
          },
        ),
      ],
    ),

    /// Products list with CRUD
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsList(),
      routes: [
        GoRoute(
          path: 'add-product',
          builder: (context, state) => const AddProductForm(),
        ),
        GoRoute(
          path: 'edit-product/:id',
          builder: (context, state) {
            final productId = state.pathParameters['id'] ?? '';
            return AddProductForm(isEditing: true, productId: productId);
          },
        ),
      ],
    ),

    /// Barcode scanner
    GoRoute(
      path: '/barcode-scanner',
      builder: (context, state) => const BarcodeScannerScreen(),
    ),

    /// Expiry OCR scanner
    GoRoute(
      path: '/expiry-ocr',
      builder: (context, state) => const ExpiryOCRScannerScreen(),
    ),

    /// Notification preferences
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationPreferencesScreen(),
    ),

    /// Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);