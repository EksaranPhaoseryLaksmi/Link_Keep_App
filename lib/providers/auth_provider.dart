import 'package:flutter/material.dart';
import '../service/auth_service.dart';

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

  Future<void> checkAuth() async {
    _isLoading = true;
    notifyListeners();

    _token = await _authService.getToken() ?? '';
    _user = await _authService.getUser();
    _isAuthenticated = _token.isNotEmpty && _user != null;

    _isLoading = false;
    notifyListeners();
  }

  /// Returns true if login successful, false otherwise
  Future<bool> login(String email, String password) async {
    final user = await _authService.login(email, password);
    if (user != null) {
      _token = await _authService.getToken() ?? '';
      _user = user;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }



  Future<void> logout() async {
    await _authService.logout();
    _token = '';
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

}
