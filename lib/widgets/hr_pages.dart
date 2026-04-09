import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/app_state.dart';
import '../theme/app_theme.dart';
import '../models/user_role.dart';

class HomeDashboardContent extends StatelessWidget {
  const HomeDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth < 600 ? 1 : (constraints.maxWidth < 900 ? 2 : 4);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: constraints.maxWidth < 600 ? 2.0 : 1.3,
                children: [
                   if (appState.currentUser?.role == UserRole.admin || appState.currentUser?.role == UserRole.hr)
                    DashboardStatCard(title: "Total Employees", value: "${appState.employees.length}", icon: Icons.people, color: primaryColor),
                  DashboardStatCard(title: "Leave Pending", value: "${appState.leaveRequests.where((e)=>e['status']=='Pending').length}", icon: Icons.assignment_rounded, color: warningColor),
                  if (appState.currentUser?.role == UserRole.admin || appState.currentUser?.role == UserRole.hr)
                    DashboardStatCard(title: "Total Users", value: "${appState.users.length}", icon: Icons.group, color: secondaryColor),
                  DashboardStatCard(title: "Notifications", value: "${appState.notifications.length}", icon: Icons.notifications, color: successColor),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("System Activity Chart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return Text(titles[value.toInt() % titles.length]);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: primaryColor)]),
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: primaryColor)]),
                        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 7, color: primaryColor)]),
                        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 9, color: primaryColor)]),
                        BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 12, color: primaryColor)]),
                        BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 6, color: primaryColor)]),
                        BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 8, color: primaryColor)]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (appState.currentUser?.role == UserRole.admin || appState.currentUser?.role == UserRole.hr) ...[
            const SizedBox(height: 30),
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Recent Employees", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appState.employees.length > 5 ? 5 : appState.employees.length,
                    itemBuilder: (context, index) {
                      final emp = appState.employees[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: primaryColor.withValues(alpha: 0.1), child: Text(emp.name[0], style: const TextStyle(color: primaryColor))),
                          title: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${emp.role.name} • ${emp.email}"),
                          trailing: const Icon(Icons.verified_user, color: successColor),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: color == primaryColor 
            ? LinearGradient(
                colors: [Colors.white, secondaryColor.withValues(alpha: 0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Colors.white, Color(0xFFFDF9F8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 14, color: textSecondary, fontWeight: FontWeight.w500)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textPrimary)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.arrow_outward, size: 14, color: textPrimary.withValues(alpha: 0.6)),
              const SizedBox(width: 4),
              Text('+2.1% This Month', style: TextStyle(color: textPrimary.withValues(alpha: 0.5), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Loading $title detail view from backend...'),
                  behavior: SnackBarBehavior.floating,
                ));
              },
              style: TextButton.styleFrom(
                foregroundColor: color,
              ),
              child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
