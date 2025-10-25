import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_row.dart';

class TaskTable extends StatelessWidget {
  final List<Task> tasks;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<Task>? onTaskTap;

  const TaskTable({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('Пока нет задач'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        final t = tasks[i];
        return Dismissible(
          key: ValueKey(t.id),
          background: Container(color: Colors.red.withOpacity(0.2)),
          onDismissed: (_) => onDelete(t.id),
          child: TaskRow(
            task: t,
            onToggle: onToggle,
            onDelete: onDelete,
            onTap: onTaskTap == null ? null : () => onTaskTap!(t),
          ),
        );
      },
    );
  }
}
