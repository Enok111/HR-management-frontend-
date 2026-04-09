import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5086/api";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);
    return await _handleResponse(response);
  }

  Future<http.Response> post(String endpoint, dynamic body) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final headers = await _getHeaders();
    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    return await _handleResponse(response);
  }

  Future<http.Response> put(String endpoint, dynamic body) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final headers = await _getHeaders();
    final response = await http.put(url, headers: headers, body: jsonEncode(body));
    return await _handleResponse(response);
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final headers = await _getHeaders();
    final response = await http.delete(url, headers: headers);
    return await _handleResponse(response);
  }

  // --- Convenience Methods ---

  Future<bool> submitPersonalInfo(Map<String, dynamic> data) async {
    final response = await post("Onboarding/personal-info", data);
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> uploadDocument(String docType, String filePath) async {
    // In a real app, this would be a MultipartRequest, but using post for now
    final response = await post("Onboarding/upload", {"type": docType, "path": filePath});
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> acceptPolicies() async {
    final response = await post("Onboarding/accept-policies", {});
    return response.statusCode == 200;
  }

  Future<bool> completeOrientation() async {
    final response = await post("Onboarding/complete-orientation", {});
    return response.statusCode == 200;
  }

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("jwt_token");
      await prefs.remove("role");
      
      // Redirect to login screen
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
      debugPrint("Unauthorized - Redirecting to login");
    } else if (response.statusCode == 403) {
      debugPrint("Forbidden access - 403");
    }
    return response;
  }
}



