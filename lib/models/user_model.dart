class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
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
      role: json['role'] ?? 'employee',
      onboardingCompleted: json['onboardingCompleted'] ?? false,
      department: json['department'],
      joiningDate: json['joiningDate'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'onboardingCompleted': onboardingCompleted,
    'department': department,
    'joiningDate': joiningDate,
  };
}
