import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../models/user_role.dart';
import '../../theme/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.fetchInitialData();
    });
  }

  List<Map<String, dynamic>> get _navigationItems {
    switch (widget.role) {
      case UserRole.employee:
        return [
          {"title": "Intelligence", "icon": Icons.query_stats, "page": const HomeDashboardContent()},
          {"title": "Profile", "icon": Icons.badge_outlined, "page": const ProfilePage()},
          {"title": "Attendance", "icon": Icons.history_toggle_off, "page": const AttendancePage()},
          {"title": "Absence", "icon": Icons.event_note, "page": const LeavePage()},
          {"title": "Finance", "icon": Icons.payments_outlined, "page": const PayrollScreen()},
          {"title": "Inquiries", "icon": Icons.support_agent, "page": const ComplaintsScreen()},
        ];
      default:
        return [
          {"title": "Intelligence", "icon": Icons.analytics_outlined, "page": const HomeDashboardContent()},
          {"title": "Workforce", "icon": Icons.people_outline, "page": const EmployeeList()},
          {"title": "Talent Acquisition", "icon": Icons.person_add_outlined, "page": const AddEmployee()},
          {"title": "Ops Monitor", "icon": Icons.monitor_heart_outlined, "page": const AttendancePage()},
          {"title": "Approvals", "icon": Icons.verified_outlined, "page": const LeavePage()},
          {"title": "Treasury", "icon": Icons.account_balance_wallet_outlined, "page": const PayrollScreen()},
          {"title": "Reporting", "icon": Icons.assessment_outlined, "page": const ReportsPage()},
          {"title": "Support Desk", "icon": Icons.forum_outlined, "page": const ComplaintsScreen()},
        ];
    }
  }

  Widget _buildSideNav(List<Map<String, dynamic>> items, bool isExpanded) {
    return Container(
      width: isExpanded ? 280 : null,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.03))),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.hub_outlined, color: primaryColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  if (isExpanded)
                    const Text('ANTIGRAVITY',
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        if (!isExpanded) Navigator.pop(context);
                      },
                      leading: Icon(items[index]['icon'],
                          color: isSelected ? primaryColor : textSecondary, size: 22),
                      title: isExpanded
                          ? Text(items[index]['title'],
                              style: TextStyle(
                                  color: isSelected ? textPrimary : textSecondary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 14))
                          : null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      selected: isSelected,
                      selectedTileColor: primaryColor.withValues(alpha: 0.05),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                appState.logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              leading: const Icon(Icons.power_settings_new, color: dangerColor, size: 22),
              title: isExpanded
                  ? const Text('Terminate Session', style: TextStyle(color: dangerColor, fontSize: 14))
                  : null,
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
      drawer: isWide ? null : Drawer(child: _buildSideNav(items, true)),
      body: Row(
        children: [
          if (isWide) _buildSideNav(items, true),
          Expanded(
            child: Column(
              children: [
                _Header(user: user, role: widget.role),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: items[_selectedIndex]['page'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final User user;
  final UserRole role;
  const _Header({required this.user, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      color: bgColor,
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width <= 950)
            IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back,', style: TextStyle(color: textSecondary, fontSize: 13)),
              Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const Spacer(),
          if (role == UserRole.employee)
            ListenableBuilder(
              listenable: appState,
              builder: (context, _) => Row(
                children: [
                  _HeaderButton(
                    onPressed: !appState.isClockedIn ? appState.checkIn : null,
                    icon: Icons.login,
                    label: appState.isClockedIn ? 'Synchronized' : 'Initialize Session',
                    color: appState.isClockedIn ? successColor : primaryColor,
                  ),
                  if (appState.isClockedIn) ...[
                    const SizedBox(width: 12),
                    _HeaderButton(
                      onPressed: appState.checkOut,
                      icon: Icons.logout,
                      label: 'Term Session',
                      color: dangerColor,
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(width: 24),
          _NotificationBadge(),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 18,
            backgroundColor: surfaceColor,
            child: const Icon(Icons.person_outline, size: 20, color: textSecondary),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const _HeaderButton({this.onPressed, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: surfaceColor,
            title: const Text('System Protocols', style: TextStyle(color: textPrimary)),
            content: SizedBox(
              width: 350,
              child: appState.notifications.isEmpty
                  ? const Text('No pending notifications', style: TextStyle(color: textSecondary))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: appState.notifications.length,
                      itemBuilder: (ctx, i) => ListTile(
                        leading: const Icon(Icons.info_outline, color: primaryColor),
                        title: Text(appState.notifications[i]['msg'], style: const TextStyle(color: textPrimary, fontSize: 14)),
                      ),
                    ),
            ),
          ),
        );
      },
      child: Stack(
        children: [
          const Icon(Icons.bolt_outlined, color: textSecondary),
          if (appState.notifications.isNotEmpty)
            Positioned(right: 0, top: 0, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle))),
        ],
      ),
    );
  }
}

class HomeDashboardContent extends StatelessWidget {
  const HomeDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Performance Intelligence', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            TextButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_list, size: 16), label: const Text('Active Protocol')),
          ],
        ),
        const SizedBox(height: 32),
        Wrap(
          runSpacing: 24,
          spacing: 24,
          children: [
            _MetricTile(title: 'Workforce Index', value: '${appState.employees.length}', icon: Icons.group_outlined, color: primaryColor, trend: '+12.5%'),
            _MetricTile(title: 'System Velocity', value: '48.4', icon: Icons.shutter_speed_outlined, color: secondaryColor, trend: '+4.2%'),
            _MetricTile(title: 'Operational ROI', value: '94%', icon: Icons.pie_chart_outline, color: tertiaryColor, trend: '+0.8%'),
            _MetricTile(title: 'Risk Profile', value: 'Minimal', icon: Icons.security_outlined, color: warningColor, trend: 'Stable'),
          ],
        ),
        const SizedBox(height: 48),
        ModernCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Trend Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor.withValues(alpha: 0.1), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(child: Icon(Icons.auto_graph_outlined, size: 64, color: primaryColor)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const _MetricTile({required this.title, required this.value, required this.icon, required this.color, required this.trend});

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 20),
                Text(trend, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personnel Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 32),
        ModernCard(
          padding: const EdgeInsets.all(40),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                child: const Icon(Icons.person_3_outlined, size: 50, color: primaryColor),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(user.role.name.toUpperCase(), style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
                    ),
                  ],
                ),
              ),
              OutlinedButton(onPressed: () {}, child: const Text('Modify Data')),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ModernCard(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _ProfileRow(label: 'Authentication Link', value: user.email, icon: Icons.alternate_email),
              _ProfileRow(label: 'Communication Direct', value: user.phone ?? 'Undesignated', icon: Icons.phone_iphone),
              _ProfileRow(label: 'Geo Coordinates', value: user.address ?? 'Undesignated', icon: Icons.map_outlined),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _ProfileRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(icon, color: textSecondary, size: 18),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: textSecondary, fontSize: 11)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('System Logs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 32),
        if (appState.notifications.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(100), child: Text('No active protocols found.', style: TextStyle(color: textSecondary))))
        else
          ListView.builder(
            shrinkWrap: true,
            itemCount: appState.notifications.length,
            itemBuilder: (context, index) {
              final notif = appState.notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ModernCard(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.sensors_outlined, color: primaryColor),
                      const SizedBox(width: 20),
                      Expanded(child: Text(notif['msg'], style: const TextStyle(fontWeight: FontWeight.w500))),
                      Text(notif['time'].toString().substring(11, 16), style: const TextStyle(color: textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
