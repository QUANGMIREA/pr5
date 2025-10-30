import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pr5/features/auth/tasks/state/tasks_container.dart';
import 'package:pr5/features/auth/services/auth_service.dart';
import 'package:pr5/features/auth/tasks/models/task.dart';
import 'package:pr5/features/auth/tasks/screens/tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService.instance;
  final List<Task> _tasks = [];

  void _addTask(String title, String? description) {
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      ));
    });
  }

  void _toggleTask(String id) {
    setState(() {
      final idx = _tasks.indexWhere((t) => t.id == id);
      if (idx != -1) {
        final t = _tasks[idx];
        _tasks[idx] = t.copyWith(isCompleted: !t.isCompleted);
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUserNotifier.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FF),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Привет, ${user?.username ?? 'друг'} 👋',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Открыть список задач (push)',
            icon: const Icon(Icons.view_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TasksPage(
                    tasks: _tasks,
                    onAdd: () => _showAddDialog(context),
                    onToggle: _toggleTask,
                    onDelete: _deleteTask,
                  ),
                ),
              );
            },
          ),
          // 2) Маршрутизированная навигация (router go) → /settings
          IconButton(
            tooltip: 'Открыть /settings (router go)',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
          // 3) Маршрутизированная навигация (router push) → /profile
          IconButton(
            tooltip: 'Перейти в профиль (router push)',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(16),
              color: task.isCompleted
                  ? Colors.indigo.shade50
                  : Colors.white,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => _toggleTask(task.id),
                  activeColor: Colors.indigo,
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color:
                    task.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                subtitle: task.description != null &&
                    task.description!.isNotEmpty
                    ? Text(
                  task.description!,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                )
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                  onPressed: () => _deleteTask(task.id),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text("Добавить задачу"),
      ),
    );
  }

  /// Giao diện khi chưa có công việc
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.indigo.shade200),
          const SizedBox(height: 16),
          Text(
            'Пока нет задач',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Нажмите кнопку «+», чтобы добавить новую задачу!',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Hộp thoại thêm công việc mới
  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Добавить новую задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Название задачи',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Описание (по желанию)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  _addTask(titleController.text, descController.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
