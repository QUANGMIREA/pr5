import 'package:flutter/material.dart';
import 'package:pr5/shared/app_theme.dart';
import 'package:pr5/features/auth/services/auth_service.dart';
import 'package:pr5/features/auth/screens/login_screen.dart';
import 'package:pr5/features/auth/screens/register_screen.dart';
import 'package:pr5/features/navigation/main_navigation.dart';
import 'package:pr5/shared/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _auth = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _auth.init().then((_) {
      if (mounted) setState(() {});
    });
    _auth.currentUserNotifier.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = _auth.currentUserNotifier.value != null;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Tasks with Auth',
      theme: AppTheme.light,

      routerConfig: appRouter,

      builder: (context, child) {
        if (!loggedIn) return const LoginScreen();
        return child ?? const MainNavigation();
      },
    );
  }
}
