import 'package:flutter/material.dart';
import 'package:pr5/features/auth/tasks/screens/tasks_list_screen.dart';

/// Устаревший контейнер, который в новой архитектуре
/// больше не управляет состоянием, а просто отображает экран списка задач.
/// Состояние теперь хранится в TasksCubit (Bloc).
class TasksContainer extends StatelessWidget {
  const TasksContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const TasksListScreen();
  }
}
