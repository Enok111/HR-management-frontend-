import 'package:flutter/material.dart';
import '../../models/employee_model.dart';
import '../../core/services/employee_service.dart';

class EditEmployeeScreen extends StatefulWidget {

  final Employee employee;

  const EditEmployeeScreen({super.key, required this.employee});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final deptController = TextEditingController();

  final EmployeeApiService apiService = EmployeeApiService();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.employee.name;
    emailController.text = widget.employee.email;
    deptController.text = widget.employee.department;
  }

  void updateEmployee() async {

    Employee emp = Employee(
      id: widget.employee.id,
      name: nameController.text,
      email: emailController.text,
      department: deptController.text,
    );

    await apiService.updateEmployee(widget.employee.id!, emp);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Employee")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: deptController,
              decoration: const InputDecoration(labelText: "Department"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateEmployee,
              child: const Text("Update"),
            )

          ],
        ),
      ),
    );
  }
}