import 'dart:convert';
import '../../models/employee_model.dart';
import '../api/api_service.dart';

class EmployeeApiService {
  final ApiService _api = ApiService();

  // GET Employees
  Future<List<Employee>> getEmployees() async {
    final response = await _api.get("Employee");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load employees (${response.statusCode})");
    }
  }

  // ADD Employee
  Future<void> addEmployee(Employee employee) async {
    final response = await _api.post("Employee", employee.toJson());
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add employee");
    }
  }

  // UPDATE Employee
  Future<void> updateEmployee(int id, Employee employee) async {
    final response = await _api.put("Employee/$id", employee.toJson());
    if (response.statusCode != 200) {
      throw Exception("Failed to update employee");
    }
  }

  // DELETE Employee
  Future<void> deleteEmployee(int id) async {
    final response = await _api.delete("Employee/$id");
    if (response.statusCode != 200) {
      throw Exception("Failed to delete employee");
    }
  }
}
