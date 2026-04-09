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
    'Sick Leave',
    'Personal Leave',
    'Maternity Leave',
    'Paternity Leave',
  ];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    appState.requestLeave(
      _selectedType,
      _startDate!.toIso8601String().split('T')[0],
      _endDate!.toIso8601String().split('T')[0],
      _reasonController.text,
    );

    // Call API: /api/leave/request (already part of appState.requestLeave simulation)


    setState(() {
      _startDate = null;
      _endDate = null;
      _reasonController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser!;
    final isManagerOrHR = user.role == UserRole.manager || user.role == UserRole.hr;

    return DefaultTabController(
      length: isManagerOrHR ? 2 : 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isManagerOrHR ? 'Leave Management' : 'My Leave', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TabBar(
              tabs: isManagerOrHR
                  ? const [
                      Tab(text: 'All Requests'),
                      Tab(text: 'My Requests'),
                    ]
                  : const [
                      Tab(text: 'Request Leave'),
                      Tab(text: 'My Requests'),
                    ],
            ),
            Expanded(
              child: TabBarView(
                children: isManagerOrHR
                    ? [
                        // All Requests Tab for HR/Manager
                        ListView.builder(
                          padding: const EdgeInsets.only(top: 24),
                          itemCount: appState.leaveRequests.length,
                          itemBuilder: (context, index) {
                            final leave = appState.leaveRequests[index];
                            final emp = appState.users.firstWhere((u) => u.id == leave['userId']);
                            return Card(
                              child: ExpansionTile(
                                title: Text('${emp.name} - ${leave['type']}'),
                                subtitle: Text('Status: ${leave['status']}'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('From: ${leave['startDate']} To: ${leave['endDate']}'),
                                        Text('Reason: ${leave['reason']}'),
                                        const SizedBox(height: 16),
                                        if (leave['status'] == 'Pending')
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  appState.updateLeaveStatus(index, 'Approved');
                                                  setState(() {});
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: successColor),
                                                child: const Text('Approve'),
                                              ),
                                              const SizedBox(width: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  appState.updateLeaveStatus(index, 'Rejected');
                                                  setState(() {});
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: dangerColor),
                                                child: const Text('Reject'),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // My Requests Tab
                        ListView.builder(
                          padding: const EdgeInsets.only(top: 24),
                          itemCount: appState.leaveRequests.where((l) => l['userId'] == user.id).length,
                          itemBuilder: (context, index) {
                            final myLeaves = appState.leaveRequests.where((l) => l['userId'] == user.id).toList();
                            final leave = myLeaves[index];
                            return Card(
                              child: ListTile(
                                title: Text('${leave['type']} - ${leave['status']}'),
                                subtitle: Text(
                                  'From: ${leave['startDate']} To: ${leave['endDate']}\nReason: ${leave['reason']}',
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: leave['status'] == 'Approved'
                                        ? successColor.withValues(alpha: 0.1)
                                        : leave['status'] == 'Rejected'
                                            ? dangerColor.withValues(alpha: 0.1)
                                            : warningColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    leave['status'],
                                    style: TextStyle(
                                      color: leave['status'] == 'Approved'
                                          ? successColor
                                          : leave['status'] == 'Rejected'
                                              ? dangerColor
                                              : warningColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ]
                    : [
                        // Request Leave Tab for Employee
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<String>(
                                initialValue: _selectedType,
                                decoration: const InputDecoration(labelText: 'Leave Type'),
                                items: _leaveTypes.map((type) {
                                  return DropdownMenuItem(value: type, child: Text(type));
                                }).toList(),
                                onChanged: (value) => setState(() => _selectedType = value!),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _selectDate(context, true),
                                      child: InputDecorator(
                                        decoration: const InputDecoration(labelText: 'Start Date'),
                                        child: Text(_startDate?.toString().split(' ')[0] ?? 'Select Date'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _selectDate(context, false),
                                      child: InputDecorator(
                                        decoration: const InputDecoration(labelText: 'End Date'),
                                        child: Text(_endDate?.toString().split(' ')[0] ?? 'Select Date'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _reasonController,
                                decoration: const InputDecoration(labelText: 'Reason'),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitLeave,
                                  child: const Text('Submit Request'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // My Requests Tab for Employee
                        ListView.builder(
                          padding: const EdgeInsets.only(top: 24),
                          itemCount: appState.leaveRequests.where((l) => l['userId'] == user.id).length,
                          itemBuilder: (context, index) {
                            final myLeaves = appState.leaveRequests.where((l) => l['userId'] == user.id).toList();
                            final leave = myLeaves[index];
                            return Card(
                              child: ListTile(
                                title: Text('${leave['type']} - ${leave['status']}'),
                                subtitle: Text(
                                  'From: ${leave['startDate']} To: ${leave['endDate']}\nReason: ${leave['reason']}',
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: leave['status'] == 'Approved'
                                        ? successColor.withValues(alpha: 0.1)
                                        : leave['status'] == 'Rejected'
                                            ? dangerColor.withValues(alpha: 0.1)
                                            : warningColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    leave['status'],
                                    style: TextStyle(
                                      color: leave['status'] == 'Approved'
                                          ? successColor
                                          : leave['status'] == 'Rejected'
                                              ? dangerColor
                                              : warningColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
