import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'add_employee_screen.dart';
import '../../models/employee_model.dart';
import '../../core/services/employee_service.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final EmployeeApiService _apiService = EmployeeApiService();
  late Future<List<Employee>> _employeesFuture;

  @override
  void initState() {
    super.initState();
    _employeesFuture = _apiService.getEmployees();
  }

  void _refresh() {
    setState(() {
      _employeesFuture = _apiService.getEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Workforce Intelligence', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Row(
              children: [
                IconButton(onPressed: _refresh, icon: const Icon(Icons.sync, size: 20)),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEmployee()),
                    );
                    _refresh();
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 16),
                  label: const Text('Add Personnel'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: FutureBuilder<List<Employee>>(
            future: _employeesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: primaryColor));
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_outlined, size: 48, color: dangerColor),
                      const SizedBox(height: 16),
                      Text('System link failed: ${snapshot.error}', style: const TextStyle(color: textSecondary)),
                      const SizedBox(height: 16),
                      TextButton(onPressed: _refresh, child: const Text('Retry Connection')),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No personnel data found in nodes.', style: TextStyle(color: textSecondary)));
              }

              final employees = snapshot.data!;
              return ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ModernCard(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: primaryColor.withValues(alpha: 0.1),
                            child: Text(emp.name[0].toUpperCase(), style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 2),
                                Text('${emp.department} • ${emp.email}', style: const TextStyle(color: textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined, color: textSecondary, size: 20),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: dangerColor, size: 20),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: surfaceColor,
                                  title: const Text('Confirm Deletion'),
                                  content: const Text('Are you sure you want to remove this node from the workforce?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remove', style: TextStyle(color: dangerColor))),
                                  ],
                                ),
                              );
                              if (confirm == true && emp.id != null) {
                                await _apiService.deleteEmployee(emp.id!);
                                _refresh();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

