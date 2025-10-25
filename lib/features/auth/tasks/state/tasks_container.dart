import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:pr5/features/auth/tasks/screens/task_form_screen.dart';
import 'package:pr5/features/auth/tasks/screens/tasks_list_screen.dart';

enum Screen { list, form }

class TasksContainer extends StatefulWidget {
  const TasksContainer({super.key});

  @override
  State<TasksContainer> createState() => _TasksContainerState();
}

class _TasksContainerState extends State<TasksContainer> {
  final List<Task> _tasks = [];
  Screen _screen = Screen.list;

  void _showList() => setState(() => _screen = Screen.list);
  void _showForm() => setState(() => _screen = Screen.form);

  void _addTask(String title, String? description) {
    setState(() {
      _tasks.add(Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      ));
      _screen = Screen.list;
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
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final removed = _tasks[idx];
    setState(() {
      _tasks.removeAt(idx);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Задача удалена'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              _tasks.insert(idx, removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_screen) {
      case Screen.list:
        return TasksListScreen(
          tasks: _tasks,
          onAdd: _showForm,
          onToggle: _toggleTask,
          onDelete: _deleteTask,
        );
      case Screen.form:
        return TaskFormScreen(
          onSave: _addTask,
          onCancel: _showList,
        );
    }
  }
}