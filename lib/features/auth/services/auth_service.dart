import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _kUsersKey = 'auth_users';
  static const _kCurrentUserKey = 'auth_current_user';

  late SharedPreferences _prefs;
  final ValueNotifier<User?> currentUserNotifier = ValueNotifier<User?>(null);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_kCurrentUserKey);
    if (raw != null) {
      currentUserNotifier.value = User.fromJson(jsonDecode(raw));
    }
  }

  Map<String, String> _readUsers() {
    final s = _prefs.getString(_kUsersKey);
    if (s == null) return {};
    final map = jsonDecode(s) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, v as String));
    // username -> password (demo)
  }

  Future<void> _writeUsers(Map<String, String> users) async {
    await _prefs.setString(_kUsersKey, jsonEncode(users));
  }

  Future<String?> register({required String username, required String password}) async {
    final users = _readUsers();
    if (users.containsKey(username)) return 'Tên người dùng đã tồn tại';
    users[username] = password; // NOTE: demo, không dùng cho sản phẩm thật
    await _writeUsers(users);

    // auto login
    final user = User(id: DateTime.now().microsecondsSinceEpoch.toString(), username: username);
    await _prefs.setString(_kCurrentUserKey, jsonEncode(user.toJson()));
    currentUserNotifier.value = user;
    return null;
  }

  Future<String?> login({required String username, required String password}) async {
    final users = _readUsers();
    if (!users.containsKey(username)) return 'Không tìm thấy người dùng';
    if (users[username] != password) return 'Mật khẩu không đúng';
    final user = User(id: DateTime.now().microsecondsSinceEpoch.toString(), username: username);
    await _prefs.setString(_kCurrentUserKey, jsonEncode(user.toJson()));
    currentUserNotifier.value = user;
    return null;
  }

  Future<void> logout() async {
    await _prefs.remove(_kCurrentUserKey);
    currentUserNotifier.value = null;
  }
}
//