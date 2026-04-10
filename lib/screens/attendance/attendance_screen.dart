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
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Operational Logs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 32),
            ModernCard(
              child: Column(
                children: [
                  const Text('Current Session Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AttendanceStatus(
                        label: 'INITIALIZE',
                        time: todayAttendance?['checkIn'],
                        isDone: todayAttendance?['checkIn'] != null,
                      ),
                      _AttendanceStatus(
                        label: 'TERMINATE',
                        time: todayAttendance?['checkOut'],
                        isDone: todayAttendance?['checkOut'] != null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: !appState.isClockedIn && todayAttendance?['checkIn'] == null ? appState.checkIn : null,
                          icon: const Icon(Icons.hub_outlined, size: 18),
                          label: const Text('Access Node'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: appState.isClockedIn ? appState.checkOut : null,
                          icon: const Icon(Icons.power_settings_new, size: 18),
                          label: const Text('End Session'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: dangerColor,
                            side: BorderSide(color: dangerColor.withValues(alpha: 0.2)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Text('Historical Ledger', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appState.attendance[user.id]?.length ?? 0,
              itemBuilder: (context, index) {
                final dates = appState.attendance[user.id]!.keys.toList().reversed.toList();
                final date = dates[index];
                final attendance = appState.attendance[user.id]![date]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ModernCard(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.event_available, color: primaryColor, size: 18),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('STAMP: $date', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Text(
                                'IO: ${attendance['checkIn'] != null ? DateTime.parse(attendance['checkIn']).toLocal().toString().substring(11, 16) : '--'} / ${attendance['checkOut'] != null ? DateTime.parse(attendance['checkOut']).toLocal().toString().substring(11, 16) : '--'}',
                                style: const TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
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
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDone ? successColor.withValues(alpha: 0.05) : surfaceColor,
            shape: BoxShape.circle,
            border: Border.all(color: isDone ? successColor.withValues(alpha: 0.2) : Colors.white10, width: 2),
            boxShadow: isDone ? [BoxShadow(color: successColor.withValues(alpha: 0.1), blurRadius: 20)] : null,
          ),
          child: Icon(
            isDone ? Icons.verified_user_outlined : Icons.radio_button_off,
            size: 24,
            color: isDone ? successColor : textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: textSecondary, fontSize: 10, letterSpacing: 1)),
        const SizedBox(height: 4),
        if (time != null)
          Text(
            DateTime.parse(time!).toLocal().toString().substring(11, 16),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          )
        else
          const Text('--:--', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white12)),
      ],
    );
  }
}


