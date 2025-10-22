import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();
  final String baseUrl = 'http://192.168.18.125:8080/api/auth';
  //final String baseUrl = 'http://192.168.137.182:8080/api/auth';
  //final String baseUrl = 'http://192.168.0.3:8080/api/auth';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      await storage.write(key: 'token', value: data['token']);
      await storage.write(key: 'user', value: jsonEncode(data['user']));
      return {'success': true, 'data': data['user']};
    } else {
      // Handle error messages sent by backend
      final msg = data['error'] ?? 'Login failed';
      return {'success': false, 'message': msg};
    }
  }

  Future<void> logout() async {
    // No API call needed since backend has no logout endpoint
    await storage.delete(key: 'token');
    await storage.delete(key: 'user');
  }


  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userString = await storage.read(key: 'user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  Future<int?> getUserTeamId() async {
    final user = await getUser();
    if (user != null && user['team_id'] != null) {
      return user['team_id'] is int
          ? user['team_id']
          : int.tryParse(user['team_id'].toString());
    }
    return null;
  }

  Future<int?> getUserId() async {
    final user = await getUser();
    if (user != null && user['id'] != null) {
      return user['id'] is int
          ? user['id']
          : int.tryParse(user['id'].toString());
    }
    return null;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String password,
    required String teamId,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'name': name,
          'team_id': teamId,
        }),
      );

      final body = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Registered successfully. Please check your email to verify your account.',
        };
      }

      // parse error
      String err = 'Registration failed (status ${response.statusCode})';
      try {
        final jsonErr = jsonDecode(body);
        if (jsonErr is Map && jsonErr.containsKey('message')) err = jsonErr['message'];
        else if (jsonErr is Map && jsonErr.containsKey('error')) err = jsonErr['error'];
        else err = body;
      } catch (_) {
        err = body;
      }
      return {'success': false, 'message': err};
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
  Future<bool> resendVerificationEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true; // email sent successfully
      } else {
        return false; // failed
      }
    } catch (_) {
      return false;
    }
  }

}
