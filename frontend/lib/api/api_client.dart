import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'https://placement-copilot-backend-production.up.railway.app';
  final _storage = const FlutterSecureStorage();

  // Helper to get default headers with optional auth token
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // GET request
  Future<http.Response> get(String endpoint, {bool requiresAuth = true}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    return await http.get(uri, headers: headers);
  }

  // POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool requiresAuth = true}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    return await http.post(uri, headers: headers, body: jsonEncode(body));
  }

  // Upload File (Multipart) request
  Future<http.Response> uploadFile(String endpoint, String filePath, String fileField, {bool requiresAuth = true}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);
    
    // Add auth header manually (don't include application/json content type)
    if (requiresAuth) {
      final token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }
    
    // Attach the file
    request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
    
    // Send request and wrap streamed response into standard response
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Store token safely
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Clear session data
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}
