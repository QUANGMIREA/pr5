import 'package:flutter/material.dart';
import '../../auth/services/auth_service.dart';
import 'package:pr5/features/navigation/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _u = TextEditingController();
  final _p = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _u.dispose();
    _p.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.instance.login(username: _u.text.trim(), password: _p.text);
    if (mounted) {
      setState(() => _loading = false);
      if (err != null) {
        setState(() => _error = err);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Войти')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: _u,
                  decoration: const InputDecoration(labelText: 'Имя пользователя'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _p,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Введите пароль' : null,
                ),
                const SizedBox(height: 12),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const CircularProgressIndicator() : const Text('Войти'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/register'),
                  child: const Text('Нет аккаунта? Зарегистрируйтесь'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
//