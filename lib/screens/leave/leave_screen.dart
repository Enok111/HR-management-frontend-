import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../models/user_role.dart';
import '../../theme/app_theme.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _reasonController = TextEditingController();
  String _selectedType = 'Annual Leave';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _leaveTypes = [
    'Annual Leave',
    'Medical Condition',
    'Personal Leave',
    'Force Majeure',
  ];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: primaryColor, onPrimary: bgColor, surface: surfaceColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitLeave() {
    if (_startDate == null || _endDate == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data nodes must be filled.')),
      );
      return;
    }

    appState.requestLeave(
      _selectedType,
      _startDate!.toIso8601String().split('T')[0],
      _endDate!.toIso8601String().split('T')[0],
      _reasonController.text,
    );

    setState(() {
      _startDate = null;
      _endDate = null;
      _reasonController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser!;
    final isManagerOrHR = user.role == UserRole.manager || user.role == UserRole.admin || user.role == UserRole.hr;

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isManagerOrHR ? 'Personnel Absence Protocols' : 'Absence Requests', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 32),
          Container(
            height: 48,
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12)),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              labelColor: primaryColor,
              unselectedLabelColor: textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: isManagerOrHR
                  ? const [Tab(text: 'System Requests'), Tab(text: 'Personal Ledger')]
                  : const [Tab(text: 'New Protocol'), Tab(text: 'Active Requests')],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1
                isManagerOrHR ? _buildAdminList() : _buildRequestForm(),
                // TAB 2
                _buildPersonalHistory(user.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestForm() {
    return SingleChildScrollView(
      child: ModernCard(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Type of Absence'),
              items: _leaveTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _selectedType = v!),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _DateSelector(label: 'BEGIN STAMP', date: _startDate, onTap: () => _selectDate(context, true))),
                const SizedBox(width: 24),
                Expanded(child: _DateSelector(label: 'END STAMP', date: _endDate, onTap: () => _selectDate(context, false))),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Justification / Context'),
              maxLines: 4,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(onPressed: _submitLeave, child: const Text('Initialize Protocol')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminList() {
    return ListView.builder(
      itemCount: appState.leaveRequests.length,
      itemBuilder: (context, index) {
        final leave = appState.leaveRequests[index];
        final matchedUsers = appState.users.where((u) => u.id == leave['userId']);
        final empName = matchedUsers.isNotEmpty ? matchedUsers.first.name : 'Unknown';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ModernCard(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$empName: ${leave['type']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${leave['startDate']} — ${leave['endDate']}', style: const TextStyle(color: textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                if (leave['status'] == 'Pending')
                  Row(
                    children: [
                      IconButton(onPressed: () => setState(() => appState.updateLeaveStatus(index, 'Approved')), icon: const Icon(Icons.check_circle_outline, color: successColor)),
                      IconButton(onPressed: () => setState(() => appState.updateLeaveStatus(index, 'Rejected')), icon: const Icon(Icons.highlight_off, color: dangerColor)),
                    ],
                  )
                else
                  Text(leave['status'].toUpperCase(), style: TextStyle(color: leave['status'] == 'Approved' ? successColor : dangerColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalHistory(String userId) {
    final myLeaves = appState.leaveRequests.where((l) => l['userId'] == userId).toList().reversed.toList();
    return ListView.builder(
      itemCount: myLeaves.length,
      itemBuilder: (context, index) {
        final leave = myLeaves[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ModernCard(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: textSecondary, size: 20),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(leave['type'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${leave['startDate']} to ${leave['endDate']}', style: const TextStyle(color: textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                _StatusBadge(status: leave['status']),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DateSelector extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DateSelector({required this.label, this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(date?.toString().split(' ')[0] ?? 'MM-DD-YYYY', style: TextStyle(color: date == null ? textSecondary : textPrimary, fontSize: 14)),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'Approved' ? successColor : (status == 'Rejected' ? dangerColor : warningColor);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}

