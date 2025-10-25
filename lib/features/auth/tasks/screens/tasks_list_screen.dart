import 'package:flutter/material.dart';
import 'package:pr5/features/auth/tasks/models/task.dart';
import 'package:pr5/features/auth/services/auth_service.dart';
import 'package:pr5/features/auth/tasks/widgets/task_table.dart';

class TasksListScreen extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onAdd;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  const TasksListScreen({
    super.key,
    required this.tasks,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUserNotifier.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FF),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade400,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Привет, ${user?.username ?? "друг"} 👋',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Выйти',
            onPressed: () async {
              await AuthService.instance.logout();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(context),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState()
                  : TaskTable(
                tasks: tasks,
                onToggle: onToggle,
                onDelete: onDelete,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add),
        label: const Text('Добавить работу'),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final total = tasks.length;
    final done = tasks.where((t) => t.isCompleted).length;
    final percent = total == 0 ? 0 : (done / total * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: total == 0 ? 0 : done / total,
            strokeWidth: 6,
            color: Colors.indigo,
            backgroundColor: Colors.indigo.shade100,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$done / $total Завершённая работа',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Прогресс: $percent%',
                  style: TextStyle(
                    color: Colors.indigo.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_outlined, size: 80, color: Colors.indigo.shade200),
          const SizedBox(height: 16),
          const Text(
            'Нет ни одной работы',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Нажмите кнопку «+», чтобы добавить новую задачу!',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
