import 'package:flutter/material.dart';
import 'package:pr5/features/auth/tasks/models/task.dart';
import 'package:pr5/features/auth/tasks/screens/tasks_list_screen.dart';

class TasksPage extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onAdd;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  const TasksPage({
    super.key,
    required this.tasks,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TasksListScreen(
      tasks: tasks,
      onAdd: onAdd,
      onToggle: onToggle,
      onDelete: onDelete,
    );
  }
}

