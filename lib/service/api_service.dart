import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.18.125:8080/api";
  //final String baseUrl = "http://192.168.18.100:8080/api";
  // String baseUrl = "http://192.168.137.182:8080/api";
  //final String baseUrl = "http://192.168.0.3:8080/api";
  final String token;

  ApiService(this.token);

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

}
