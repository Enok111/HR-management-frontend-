import 'user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool onboardingCompleted;
  final String? department;
  final String? joiningDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.onboardingCompleted = false,
    this.department,
    this.joiningDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: _parseRole(json['role']),
      onboardingCompleted: json['onboardingCompleted'] ?? false,
      department: json['department'],
      joiningDate: json['joiningDate'],
    );
  }

  static UserRole _parseRole(dynamic role) {
    if (role == null) return UserRole.employee;
    final String roleStr = role.toString().toLowerCase();
    if (roleStr == 'admin') return UserRole.admin;
    if (roleStr == 'hr') return UserRole.hr;
    if (roleStr == 'manager') return UserRole.manager;
    return UserRole.employee;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
    'onboardingCompleted': onboardingCompleted,
    'department': department,
    'joiningDate': joiningDate,
  };
}
