import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Category.dart';

class ApiService {
  final String baseUrl = "http://192.168.18.125:8080/api";
  final String token;

  ApiService(this.token);

  // ---------------- Change Password ----------------
  Future<bool> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/changepwd'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['message'] == "Password updated successfully";
    } else {
      return false;
    }
  }

  // ---------------- Fetch Categories ----------------
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/category'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // ---------------- Create Link / Content ----------------
  Future<bool> createLink(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/link'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = utf8.decode(response.bodyBytes);
      throw Exception('Failed to create link: $body');
    }
  }

  Future<List<Map<String, dynamic>>> getLinks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/link'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to fetch links');
    }
  }

  Future<bool> updateLink(String id, Map<String, dynamic> data) async {
    // Ensure id is included in data as your API requires
    data['id'] = id;

    final response = await http.put(
      Uri.parse('$baseUrl/link'), // PUT to /link without id in URL
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = utf8.decode(response.bodyBytes);
      throw Exception('Failed to update link: $body');
    }
  }
// ---------------- Add New Category ----------------
  Future<bool> addCategory(Map<String, dynamic> categoryData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/category'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(categoryData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final body = utf8.decode(response.bodyBytes);
      throw Exception('Failed to add category: $body');
    }
  }

  // ---------------- Update Category ----------------
  Future<bool> updateCategory(Map<String, dynamic> categoryData) async {
    // Ensure 'id' is included in the body as your API requires
    if (!categoryData.containsKey('id')) {
      throw Exception('Category ID is required for update');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/category'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(categoryData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = utf8.decode(response.bodyBytes);
      throw Exception('Failed to update category: $body');
    }
  }
}
