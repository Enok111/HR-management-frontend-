import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../theme/app_theme.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalUsers = appState.users.length;
    final totalEmployees = appState.employees.length;
    final pendingLeaves = appState.leaveRequests.where((l) => l['status'] == 'Pending').length;
    final approvedLeaves = appState.leaveRequests.where((l) => l['status'] == 'Approved').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                childAspectRatio: constraints.maxWidth < 600 ? 2.5 : 1.5,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildReportCard('Total Users', totalUsers.toString(), Icons.people, primaryColor),
                  _buildReportCard('Total Employees', totalEmployees.toString(), Icons.work, secondaryColor),
                  _buildReportCard('Pending Leaves', pendingLeaves.toString(), Icons.schedule, warningColor),
                  _buildReportCard('Approved Leaves', approvedLeaves.toString(), Icons.check_circle, successColor),
                ],
              );
            }
          ),
          const SizedBox(height: 32),
          const Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appState.auditLogs.length,
            itemBuilder: (context, index) {
              final log = appState.auditLogs[appState.auditLogs.length - 1 - index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(log['action']),
                  subtitle: Text(log['time'].toString()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: textSecondary)),
          ],
        ),
      ),
    );
  }
}
