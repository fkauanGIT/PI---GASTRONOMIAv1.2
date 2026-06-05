import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }

    return 'http://localhost:8000';
  }

  static Uri _buildUri(String path) => Uri.parse('$baseUrl$path');

  static String? _accessToken;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
  }

  static Future<void> setToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<void> clearToken() async {
    _accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static String? get token => _accessToken;
  static bool get isAuthenticated => _accessToken != null;

  static Map<String, String> get headers {
    final Map<String, String> h = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_accessToken != null) {
      h['Authorization'] = 'Bearer $_accessToken';
    }
    return h;
  }

  static Future<AuthResponse> login(String username, String password) async {
    final url = _buildUri('/api/v1/auth/login');
    debugPrint('Login: $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      debugPrint('Login status: ${response.statusCode}');
      debugPrint('Login body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final authResponse = AuthResponse.fromJson(data);
        await setToken(authResponse.accessToken);
        return authResponse;
      } else {
        throw ApiException(data['message'] ?? 'Login falhou',
            statusCode: response.statusCode);
      }
    } catch (e) {
      debugPrint('Erro no login: $e');
      rethrow;
    }
  }

  static Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    String? fullName,
  }) async {
    final url = _buildUri('/api/v1/auth/register');
    debugPrint('Registro: $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'full_name': fullName,
        }),
      );

      debugPrint('Registro status: ${response.statusCode}');
      debugPrint('Registro body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return UserModel.fromJson(data['data']);
      } else {
        throw ApiException(data['message'] ?? 'Registro falhou',
            statusCode: response.statusCode);
      }
    } catch (e) {
      debugPrint('Erro no registro: $e');
      rethrow;
    }
  }

  static Future<void> logout() async => clearToken();

  static Future<UserModel> getCurrentUser() async {
    final response = await http.get(_buildUri('/api/v1/users/me'), headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return UserModel.fromJson(data['data']);
    } else {
      throw ApiException(data['message'] ?? 'Falha ao obter usuário',
          statusCode: response.statusCode);
    }
  }

  static Future<UserModel> updateUser(Map<String, dynamic> userData) async {
    final response = await http.put(
      _buildUri('/api/v1/users/me'),
      headers: headers,
      body: jsonEncode(userData),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return UserModel.fromJson(data['data']);
    } else {
      throw ApiException(data['message'] ?? 'Falha ao atualizar usuário',
          statusCode: response.statusCode);
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(_buildUri(endpoint), headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(data['message'] ?? 'Requisição falhou',
          statusCode: response.statusCode);
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final response = await http.post(
      _buildUri(endpoint),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(data['message'] ?? 'Requisição falhou',
          statusCode: response.statusCode);
    }
  }
}
