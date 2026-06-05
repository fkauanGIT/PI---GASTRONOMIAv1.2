import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

enum AuthStatus { uninitialized, authenticating, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.authenticating;

  static const _currentUserKey = 'current_user';
  static const _usersKey = 'local_users';

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      try {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        _user = UserModel(
          id: map['id'] as int,
          email: map['email'] as String,
          username: map['username'] as String,
          fullName: map['fullName'] as String?,
        );
        _status = AuthStatus.authenticated;
      } catch (_) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw) as List);
  }

  Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    try {
      final users = await _getUsers();

      Map<String, dynamic>? found;
      for (final u in users) {
        if (u['email'] == email && u['password'] == password) {
          found = u;
          break;
        }
      }

      // Modo demo: aceita qualquer credencial válida se não houver usuários cadastrados
      if (found == null && users.isEmpty) {
        found = {
          'id': DateTime.now().millisecondsSinceEpoch,
          'email': email,
          'username': email.split('@').first,
          'fullName': 'Usuário',
          'password': password,
        };
      }

      if (found == null) {
        _errorMessage = 'E-mail ou senha incorretos';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      _user = UserModel(
        id: found['id'] as int,
        email: found['email'] as String,
        username: found['username'] as String,
        fullName: found['fullName'] as String?,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, jsonEncode(found));

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao fazer login. Tente novamente.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    try {
      final users = await _getUsers();

      if (users.any((u) => u['email'] == email)) {
        _errorMessage = 'E-mail já cadastrado. Tente fazer login.';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      final newUser = <String, dynamic>{
        'id': DateTime.now().millisecondsSinceEpoch,
        'email': email,
        'username': username,
        'fullName': fullName ?? '',
        'password': password,
      };

      users.add(newUser);
      await _saveUsers(users);

      // Auto-login após cadastro
      _user = UserModel(
        id: newUser['id'] as int,
        email: newUser['email'] as String,
        username: newUser['username'] as String,
        fullName: newUser['fullName'] as String?,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, jsonEncode(newUser));
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao cadastrar. Tente novamente.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
