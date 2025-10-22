import 'package:flutter/material.dart';
import '../service/auth_service.dart';

/// Custom exception for unverified email
class UnverifiedEmailException implements Exception {
  final String message;
  UnverifiedEmailException(this.message);
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;
  bool _isLoading = true;
  String _token = '';
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String get token => _token;
  Map<String, dynamic>? get user => _user;

  /// Check if user is already logged in
  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    _token = await _authService.getToken() ?? '';
    _user = await _authService.getUser();
    _isAuthenticated = _token.isNotEmpty && _user != null;

    _isLoading = false;
    notifyListeners();
  }

  /// Login with email and password
  /// Throws [UnverifiedEmailException] if email not verified
  /// Returns true if login successful, false for invalid credentials
  Future<bool> login(String email, String password) async {
    final result = await _authService.login(email, password);
    if(result!=null)
      {
        if (result['success'] == true) {
          // Successful login
          _token = await _authService.getToken() ?? '';
          _user = result['data'];
          _isAuthenticated = true;
          notifyListeners();
          return true;
        } else {
          final message = result['message'] ?? 'Login failed';
          // Detect unverified email
          if (message.toLowerCase().contains('verify your email')) {
            throw UnverifiedEmailException(message);
          }
          return false; // invalid credentials
        }
      }
    return false;
  }

  /// Resend verification email
  Future<bool> resendVerificationEmail(String email) async {
    try {
      final result = await _authService.resendVerificationEmail(email);
      return result;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _authService.logout();
    _token = '';
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
