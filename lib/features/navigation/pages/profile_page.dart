import 'package:flutter/material.dart';
import 'package:pr5/features/auth/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> _avatarUrls = const [
    'https://loremflickr.com/800/600/nature?lock=40',
    'https://loremflickr.com/800/600/nature?lock=41',
    'https://loremflickr.com/800/600/nature?lock=42',
    'https://loremflickr.com/800/600/nature?lock=43',
    'https://loremflickr.com/800/600/nature?lock=44',

  ];

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUserNotifier.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Center(
        child: user == null
            ? const Text('Не выполнен вход')
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 80),
              const SizedBox(height: 16),
              Text(
                'Имя пользователя: ${user.username}',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 20),
              const Text(
                'Галерея пользователя',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 14,
                runSpacing: 14,
                children: _avatarUrls
                    .map((url) => _RoundedAvatar(url: url, size: 64))
                    .toList(),
              ),

              const SizedBox(height: 28),
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
      ),
    );
  }
}

class _RoundedAvatar extends StatelessWidget {
  const _RoundedAvatar({required this.url, this.size = 64});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          memCacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
          memCacheHeight: (size * MediaQuery.devicePixelRatioOf(context)).round(),
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                value: progress.progress,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFFEDEDED),
            child: const Icon(Icons.person_off, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
