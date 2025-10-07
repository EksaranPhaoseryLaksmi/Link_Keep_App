import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();
  final String baseUrl = 'http://192.168.18.125:8080/api/auth';
  //final String baseUrl = 'http://192.168.137.182:8080/api/auth';
  //final String baseUrl = 'http://192.168.0.3:8080/api/auth';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      // Save user info as JSON string
      await storage.write(key: 'user', value: jsonEncode(data['user']));
      return data['user']; // return user info
    }

    return null;
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
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourapi.com/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

}
