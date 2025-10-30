import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pr5/features/navigation/pages/home_page.dart';
import 'package:pr5/features/navigation/pages/profile_page.dart';
import 'package:pr5/features/navigation/pages/settings_page.dart';
import 'package:pr5/features/auth/tasks/screens/tasks_page.dart';
import 'package:pr5/features/auth/tasks/models/task.dart';

class AppState extends ChangeNotifier {
  final List<Task> tasks = [];
}

final appState = AppState();

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    GoRoute(
      path: '/tasks',
      builder: (_, __) => TasksPage(
        tasks: appState.tasks,
        onAdd: () {},
        onToggle: (_) {},
        onDelete: (_) {},
      ),
    ),
  ],
);
