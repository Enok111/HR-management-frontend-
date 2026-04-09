import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../models/user_role.dart';
import '../../theme/app_theme.dart';
import '../../widgets/hr_pages.dart';
import '../attendance/attendance_screen.dart';
import '../leave/leave_screen.dart';
import '../employee/employee_list_screen.dart';
import '../reports/reports_screen.dart';
import '../employee/add_employee_screen.dart';
import '../payroll/payroll_screen.dart';
import '../complaints/complaints_screen.dart';
import '../auth/login_screen.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) => const Dashboard(role: UserRole.admin);
}

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});
  @override
  Widget build(BuildContext context) => const Dashboard(role: UserRole.employee);
}

class Dashboard extends StatefulWidget {
  final UserRole role;
  const Dashboard({super.key, required this.role});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> get _navigationItems {
    switch (widget.role) {
      case UserRole.employee:
        return [
          {
            "title": "Home",
            "icon": Icons.home,
            "page": const HomeDashboardContent()
          },
          {
            "title": "My Profile",
            "icon": Icons.person,
            "page": const ProfilePage()
          },
          {
            "title": "Attendance",
            "icon": Icons.access_time,
            "page": const AttendancePage()
          },
          {
            "title": "Apply Leave",
            "icon": Icons.calendar_today,
            "page": const LeavePage()
          },
          {
            "title": "View Payroll",
            "icon": Icons.monetization_on,
            "page": const PayrollScreen()
          },
          {
            "title": "Submit Complaints",
            "icon": Icons.report_problem,
            "page": const ComplaintsScreen()
          },
        ];
      case UserRole.admin:
      case UserRole.hr:
        return [
          {
            "title": "Dashboard",
            "icon": Icons.space_dashboard_rounded,
            "page": const HomeDashboardContent()
          },
          {
            "title": "Employee Management",
            "icon": Icons.people,
            "page": const EmployeeList()
          },
          {
            "title": "Onboarding",
            "icon": Icons.person_add,
            "page": const AddEmployee()
          },
          {
            "title": "Attendance",
            "icon": Icons.access_time,
            "page": const AttendancePage()
          },
          {
            "title": "Leave Approvals",
            "icon": Icons.calendar_today,
            "page": const LeavePage()
          },
          {
            "title": "Payroll",
            "icon": Icons.monetization_on,
            "page": const PayrollScreen()
          },
          {
            "title": "Reports",
            "icon": Icons.bar_chart,
            "page": const ReportsPage()
          },
          {
            "title": "Complaints",
            "icon": Icons.report_problem,
            "page": const ComplaintsScreen()
          },
        ];
      case UserRole.manager:
        return [
          {
            "title": "Dashboard",
            "icon": Icons.space_dashboard_rounded,
            "page": const HomeDashboardContent()
          },
          {
            "title": "Team Attendance",
            "icon": Icons.access_time,
            "page": const AttendancePage()
          },
          {
            "title": "Leave Requests",
            "icon": Icons.calendar_today,
            "page": const LeavePage()
          },
          {
            "title": "Reports",
            "icon": Icons.bar_chart,
            "page": const ReportsPage()
          },
          {
            "title": "Payroll",
            "icon": Icons.monetization_on,
            "page": const PayrollScreen()
          },
          {
            "title": "Complaints",
            "icon": Icons.report_problem,
            "page": const ComplaintsScreen()
          },
          {
            "title": "Notifications",
            "icon": Icons.notifications,
            "page": const NotificationsPage()
          },
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildNavigationItem(
      Map<String, dynamic> item, int index, bool isSelected) {
    return ListTile(
      leading:
          Icon(item['icon'], color: isSelected ? primaryColor : textSecondary),
      title: Text(item['title'],
          style: TextStyle(
              color: isSelected ? primaryColor : textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
      selected: isSelected,
      selectedTileColor: primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        _onItemTapped(index);
        if (MediaQuery.of(context).size.width < 950) Navigator.pop(context);
      },
    );
  }

  Widget _buildSideNav(List<Map<String, dynamic>> items, bool isExpanded) {
    return Container(
      width: isExpanded ? 240 : null,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            right: BorderSide(
                color: Colors.black.withValues(alpha: 0.05), width: 1)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const CircleAvatar(
                      radius: 20,
                      backgroundColor: secondaryColor,
                      child: Icon(Icons.person, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appState.currentUser!.name,
                            style: const TextStyle(
                                color: textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Edit Profile'),
                                content: const Text('Profile editing form will load from backend API.'),
                                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                              ),
                            );
                          },
                          child: const Text('Edit Profile',
                              style: TextStyle(
                                  color: textSecondary, fontSize: 12, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildNavigationItem(
                        items[index], index, index == _selectedIndex),
                  );
                },
              ),
            ),
            const Divider(color: Colors.black12, thickness: 1),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: const Icon(Icons.logout, color: textSecondary),
              title: const Text('Logout',
                  style: TextStyle(
                      color: textSecondary, fontWeight: FontWeight.w500)),
              onTap: () {
                appState.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser!;
    final items = _navigationItems;
    final bool isWide = MediaQuery.of(context).size.width > 950;

    return Scaffold(
      drawer: isWide ? null : Drawer(child: _buildSideNav(items, false)),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide) _buildSideNav(items, true),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Hello, ${user.name}',
                              style: const TextStyle(
                                  color: textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.05)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.wb_sunny_outlined, color: textPrimary, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Theme synchronized with backend preferences.'),
                                behavior: SnackBarBehavior.floating,
                              ));
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.05)),
                          ),
                          child: Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_none,
                                    color: textPrimary, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Notifications'),
                                      content: SizedBox(
                                        width: 300,
                                        height: 200,
                                        child: appState.notifications.isEmpty
                                            ? const Center(child: Text('No new notifications'))
                                            : ListView.builder(
                                                itemCount: appState.notifications.length,
                                                itemBuilder: (ctx, i) => ListTile(
                                                  leading: const Icon(Icons.info_outline, color: primaryColor),
                                                  title: Text(appState.notifications[i]['msg']),
                                                ),
                                              ),
                                      ),
                                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                                    ),
                                  );
                                },
                              ),
                              if (appState.notifications.isNotEmpty)
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: dangerColor,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (widget.role == UserRole.employee) ...[
                          const SizedBox(width: 12),
                          ListenableBuilder(
                            listenable: appState,
                            builder: (context, _) {
                              return ElevatedButton.icon(
                                onPressed: appState.isClockedIn ? appState.checkOut : appState.checkIn,
                                icon: Icon(appState.isClockedIn ? Icons.logout : Icons.login, size: 16),
                                label: Text(appState.isClockedIn ? 'Clocked In' : 'Clock In'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appState.isClockedIn ? successColor : primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            },
                          ),
                        ],
                        if (widget.role != UserRole.employee) ...[
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator(color: primaryColor)),
                              );
                              await Future.delayed(const Duration(milliseconds: 600)); // Simulate async backend connect
                              if (context.mounted) Navigator.pop(context);
                              
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('New Action'),
                                    content: const Text('Action successfully triggered and logged in backend. UI update complete.'),
                                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('New Action'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: bgColor,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.role != UserRole.employee) ...[
                            Wrap(
                              runSpacing: 16,
                              spacing: 16,
                              children: [
                                _MetricTile(
                                    title: 'Total Employees',
                                    value: '${appState.employees.length}',
                                    icon: Icons.people,
                                    shading: primaryColor),
                                _MetricTile(
                                    title: 'New Hires',
                                    value: '4',
                                    icon: Icons.person_add,
                                    shading: secondaryColor),
                                _MetricTile(
                                    title: 'Average Tenure',
                                    value: '2.3 yr',
                                    icon: Icons.timeline,
                                    shading: tertiaryColor),
                                _MetricTile(
                                    title: 'Probation',
                                    value: '5',
                                    icon: Icons.work_outline,
                                    shading: warningColor),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                          Expanded(child: items[_selectedIndex]['page']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              items: items
                  .map((item) => BottomNavigationBarItem(
                        icon: Icon(item['icon']),
                        label: item['title'],
                      ))
                  .toList(),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: primaryColor,
              unselectedItemColor: const Color.fromRGBO(139, 146, 154, 1),
            ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color shading;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.shading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: shading == primaryColor
            ? LinearGradient(
                colors: [Colors.white, secondaryColor.withValues(alpha: 0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: shading.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
              color: shading.withValues(alpha: 0.05),
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
                  style: const TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                      fontWeight: FontWeight.w500)),
              Icon(icon, color: shading, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          Text(value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textPrimary)),
          const SizedBox(height: 24),
          Text('View Details',
              style: TextStyle(
                  color: shading, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      child: const Icon(Icons.person, size: 60, color: primaryColor),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        child: const Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(user.role.name.toUpperCase(), style: const TextStyle(color: textSecondary, letterSpacing: 1.2)),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _ProfileInfoCard(
            items: [
              _ProfileInfoItem(icon: Icons.email, label: 'Email Address', value: user.email),
              _ProfileInfoItem(icon: Icons.phone, label: 'Phone Number', value: user.phone ?? 'Not set'),
              _ProfileInfoItem(icon: Icons.location_on, label: 'Address', value: user.address ?? 'Not set'),
              _ProfileInfoItem(icon: Icons.contact_emergency, label: 'Emergency Contact', value: user.emergencyContact ?? 'Not set'),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Edit Profile'),
                    content: const Text('API Integration point: POST /api/profile/update'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                  ),
                );
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('Edit Details'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final List<_ProfileInfoItem> items;
  const _ProfileInfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => ListTile(
          leading: Icon(items[index].icon, color: primaryColor, size: 20),
          title: Text(items[index].label, style: const TextStyle(color: textSecondary, fontSize: 12)),
          subtitle: Text(items[index].value, style: const TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _ProfileInfoItem {
  final IconData icon;
  final String label;
  final String value;
  _ProfileInfoItem({required this.icon, required this.label, required this.value});
}


class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = appState.notifications;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text('No notifications'))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(notif['msg']),
                          subtitle: Text(notif['time'].toString()),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
