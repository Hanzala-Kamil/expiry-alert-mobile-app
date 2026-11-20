import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/home/home.dart';
import 'features/products/products.dart';
import 'features/add_product/add_product.dart';
import 'features/settings/settings.dart';
import 'features/onboarding/onboarding.dart';
import 'features/authentication/auth.dart';
import 'core/theme/theme.dart';

/// The root application widget that sets up the global provider scope
/// and determines the initial route based on authentication state.
class ExpiryAlertApp extends ConsumerWidget {
  const ExpiryAlertApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the initial auth state to determine navigation
    final initialRoute = ref.watch(initialRouteProvider);

    return MaterialApp.router(
      title: 'ExpiryAlert',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerDelegate: ref.wire().routerDelegate,
      routeInformationParser: ref.wire().routeInformationParser,
      routeInformationProvider: ref.wire().routeInformationProvider,
      routePathParser: ref.wire().routePathParser,
      routes: {
        '/': (context) => const Scaffold(
          body: Center(
            child: Text('ExpiryAlert'),
          ),
        ),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const AuthScreen(authType: AuthType.login),
        '/register': (context) => const AuthScreen(authType: AuthType.register),
        '/home': (context) => const HomeDashboard(),
        '/products': (context) => const ProductsList(),
        '/add-product': (context) => const AddProductForm(),
        '/settings': (context) => const SettingsScreen(),
      },
      initialRoute: initialRoute,
    );
  }
}