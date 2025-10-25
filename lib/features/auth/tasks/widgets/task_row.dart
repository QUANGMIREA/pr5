import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskRow extends StatelessWidget {
  final Task task;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final VoidCallback? onTap;
  const TaskRow({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium!;
    final deco = task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none;

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => onToggle(task.id),
      ),
      title: Text(task.title, style: style.copyWith(decoration: deco)),
      subtitle: task.description?.isNotEmpty == true ? Text(task.description!) : null,
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => onDelete(task.id),
        tooltip: 'Удалить',
      ),
    );
  }
}
