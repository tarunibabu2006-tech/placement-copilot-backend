import 'dart:convert';
import 'package:flutter/material.dart';
import '../api/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;

  // Check if user is already authenticated on start
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _apiClient.getToken();
      if (token != null) {
        final response = await _apiClient.get('/auth/me');
        if (response.statusCode == 200) {
          _currentUser = jsonDecode(response.body);
          _isAuthenticated = true;
        } else {
          // Token expired or invalid
          await _apiClient.logout();
          _isAuthenticated = false;
        }
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      _errorMessage = "Network error. Please try again.";
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register a new user
  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.post('/auth/register', {
        'email': email,
        'password': password,
      }, requiresAuth: false);

      if (response.statusCode == 200) {
        return await login(email, password);
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['detail'] ?? 'Registration failed';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection timed out. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login action
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.post('/auth/login', {
        'email': email,
        'password': password,
      }, requiresAuth: false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        await _apiClient.saveToken(token);
        
        // Fetch current user details
        final userResponse = await _apiClient.get('/auth/me');
        if (userResponse.statusCode == 200) {
          _currentUser = jsonDecode(userResponse.body);
          _isAuthenticated = true;
          return true;
        }
      }
      
      final data = jsonDecode(response.body);
      _errorMessage = data['detail'] ?? 'Invalid credentials';
      return false;
    } catch (e) {
      _errorMessage = 'Network connection failed.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout action
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _apiClient.logout();
    _currentUser = null;
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
  }
}
