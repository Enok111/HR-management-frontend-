import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';

class LoginResponse {
  final String? token;
  final String? error;
  final String? email;
  final String? role;

  LoginResponse({
    this.token,
    this.error,
    this.email,
    this.role,
  });
}

class AuthService {
  final ApiService _api = ApiService();

  Future<LoginResponse> login(
      {required String email, required String password}) async {
    try {
      final response = await _api.post("Auth/login", {"email": email, "password": password});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String? token = data["token"];
        final String? role = data["role"];
        final String? userEmail = data["email"];

        if (token == null || token.isEmpty) {
          return LoginResponse(error: "Token not found in response");
        }

        // Save token and role to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("jwt_token", token);
        if (role != null) {
          await prefs.setString("role", role);
        }

        return LoginResponse(
          token: token,
          email: userEmail,
          role: role,
        );
      } else {
        String errorMessage = "Login failed (${response.statusCode})";
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          errorMessage = errorData["message"] ?? errorData["error"] ?? errorMessage;
        } catch (_) {}
        return LoginResponse(error: errorMessage);
      }
    } catch (e) {
      return LoginResponse(
          error: "Connection error: Please check if the server is running");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
    await prefs.remove("role");
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }
}