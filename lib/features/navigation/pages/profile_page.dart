import 'package:flutter/material.dart';
import 'package:pr5/features/auth/services/auth_service.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUserNotifier.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Center(
        child: user == null
            ? const Text('Не выполнен вход')
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 80),
            const SizedBox(height: 16),
            Text(
              'Имя пользователя: ${user.username}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService.instance.logout();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (_) => false);
                }
              },
              label: const Text('Выйти из системы'),
            ),
          ],
        ),
      ),
    );
  }
}
