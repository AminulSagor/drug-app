import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthStorage {
  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';

  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _secure.write(key: _kToken, value: token);
  }

  Future<String?> readToken() async {
    return _secure.read(key: _kToken);
  }

  Future<void> clearToken() async {
    await _secure.delete(key: _kToken);
  }

  Future<void> saveUser(UserModel user) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUser, jsonEncode(user.toJson()));
  }

  Future<UserModel?> readUser() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kUser);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearUser() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kUser);
  }

  Future<void> clearAll() async {
    await clearToken();
    await clearUser();
  }
}
