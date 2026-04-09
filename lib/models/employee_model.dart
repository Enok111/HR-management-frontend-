class Employee {
  int? id;
  String name;
  String email;
  String department;

  Employee({
    this.id,
    required this.name,
    required this.email,
    required this.department,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "department": department,
    };
  }
}