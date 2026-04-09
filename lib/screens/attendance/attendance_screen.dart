import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../theme/app_theme.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser!;
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final todayAttendance = appState.attendance[user.id]?[today];
        
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Attendance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('Today\'s Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _AttendanceStatus(
                            label: 'Check In',
                            time: todayAttendance?['checkIn'],
                            isDone: todayAttendance?['checkIn'] != null,
                          ),
                          _AttendanceStatus(
                            label: 'Check Out',
                            time: todayAttendance?['checkOut'],
                            isDone: todayAttendance?['checkOut'] != null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: !appState.isClockedIn && todayAttendance?['checkIn'] == null ? appState.checkIn : null,
                              icon: const Icon(Icons.login),
                              label: const Text('Check In'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: appState.isClockedIn ? appState.checkOut : null,
                              icon: const Icon(Icons.logout),
                              label: const Text('Check Out'),
                              style: ElevatedButton.styleFrom(backgroundColor: dangerColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Recent Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: appState.attendance[user.id]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final dates = appState.attendance[user.id]!.keys.toList().reversed.toList();
                    final date = dates[index];
                    final attendance = appState.attendance[user.id]![date]!;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: const Icon(Icons.calendar_today, color: primaryColor, size: 16),
                        ),
                        title: Text('Date: $date'),
                        subtitle: Text(
                          'Check In: ${attendance['checkIn'] != null ? DateTime.parse(attendance['checkIn']).toLocal().toString().split(' ')[1].substring(0, 5) : 'N/A'} | '
                          'Check Out: ${attendance['checkOut'] != null ? DateTime.parse(attendance['checkOut']).toLocal().toString().split(' ')[1].substring(0, 5) : 'N/A'}',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AttendanceStatus extends StatelessWidget {
  final String label;
  final String? time;
  final bool isDone;
  const _AttendanceStatus({required this.label, this.time, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 48,
          color: isDone ? successColor : textSecondary,
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        if (time != null)
          Text(
            DateTime.parse(time!).toLocal().toString().split(' ')[1].substring(0, 5),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
      ],
    );
  }
}

