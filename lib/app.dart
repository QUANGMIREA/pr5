import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/tasks/state/tasks_container.dart';
import 'features/navigation/main_navigation.dart';

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks with Auth',
      theme: AppTheme.light,
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/tasks': (_) => const TasksContainer(),
      },
      home: loggedIn ? const MainNavigation() : const LoginScreen(),
    );
  }
}
