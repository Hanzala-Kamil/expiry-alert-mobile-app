import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app/router.dart';
import 'app/app.dart';

void main() {
  runApp(const ExpiryAlertApp());
}

class ExpiryAlertApp extends ConsumerStatefulWidget {
  const ExpiryAlertApp({super.key});

  @override
  ConsumerState<ExpiryAlertApp> createState() => _ExpiryAlertAppState();
}

class _ExpiryAlertAppState extends ConsumerState<ExpiryAlertApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Firebase/Supabase, permissions, etc. here
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ExpiryAlert',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerDelegate: ref.wire().routerDelegate,
      routeInformationParser: ref.wire().routeInformationParser,
      routeInformationProvider: ref.wire().routeInformationProvider,
      routePathParser: ref.wire().routePathParser,
    );
  }
}