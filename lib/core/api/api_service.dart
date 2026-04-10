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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");

    var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/Onboarding/upload-document"));
    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }
    
    request.fields['documentType'] = docType;
    request.files.add(http.MultipartFile.fromString('file', 'mock content', filename: 'dummy.pdf'));

    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> acceptPolicies() async {
    final response = await post("Onboarding/accept-policies", {});
    return response.statusCode == 200;
  }

  Future<bool> getOnboardingStatus() async {
    try {
      final response = await get("Onboarding/status");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["status"] == "Completed";
      }
    } catch (_) {}
    return false;
  }

  Future<Map<String, dynamic>?> getJobDetails() async {
    final response = await get("Onboarding/job-details");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<bool> clockIn() async {
    final response = await post("Attendance/clockin", {});
    return response.statusCode == 200;
  }

  Future<bool> clockOut() async {
    final response = await post("Attendance/clockout", {});
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getMyAttendance() async {
    final response = await get("Attendance/myattendance");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<bool> submitLeave(Map<String, dynamic> request) async {
    final response = await post("Leave/submit", request);
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getMyLeaves() async {
    final response = await get("Leave/my-leaves");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<List<dynamic>> getAllAttendance() async {
    final response = await get("Attendance/all");
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  Future<List<dynamic>> getAllLeaves() async {
    final response = await get("Leave/all");
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  Future<bool> actionLeave(int id, String status) async {
    final response = await put("Leave/action/$id?status=$status", {});
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getEmployees() async {
    final response = await get("Employee");
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  Future<bool> completeOrientation() async {
    final response = await post("Onboarding/orientation/complete", {});
    return response.statusCode == 200;
  }

  Future<bool> completeOnboarding() async {
    final response = await post("Onboarding/complete", {});
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



