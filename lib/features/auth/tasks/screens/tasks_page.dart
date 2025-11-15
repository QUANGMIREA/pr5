import 'package:flutter/material.dart';
import 'package:pr5/features/auth/tasks/models/task.dart';
import 'package:pr5/features/auth/tasks/screens/tasks_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pr5/features/auth/tasks/state/task_cubit.dart';

class TasksPage extends StatelessWidget {
  final List<Task> initialTasks;

  const TasksPage({
    super.key,
    required this.initialTasks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit()..loadInitial(initialTasks),
      child: const TasksListScreen(),
    );
  }
}

