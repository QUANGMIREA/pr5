import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouter, GoRouterState, contextGo, GoRouterHelper; // nếu chưa dùng GoRouter, import này không lỗi
import 'package:pr5/features/navigation/pages/profile_page.dart';
import 'package:pr5/features/navigation/main_navigation.dart'; // fallback về Home tab

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _goHome(BuildContext context) {
    // 1) Nếu có route trước đó -> pop
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    // 2) Nếu app dùng GoRouter -> go('/')
    try {
      // nếu GoRouter có mặt, lệnh này sẽ hoạt động
      context.go('/');
      return;
    } catch (_) {
      // ignore: nếu không dùng GoRouter sẽ nhảy sang bước 3
    }

    // 3) Fallback: thay toàn bộ stack bằng MainNavigation (Home tab)
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Назад к главной странице',
          onPressed: () => _goHome(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Тёмный режим (Dark Mode)'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Функция находится в разработке...')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            subtitle: const Text('Версия 1.0.0'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Перейти в профиль (pushReplacement)'),
            subtitle: const Text('Горизонтальная навигация: назад нельзя'),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
