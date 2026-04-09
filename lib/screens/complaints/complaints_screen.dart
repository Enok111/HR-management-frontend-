import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../theme/app_theme.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _complaintController = TextEditingController();
  final List<Map<String, String>> _complaints = [
    {'title': 'AC not working', 'status': 'Resolved', 'date': '2026-03-15'},
    {'title': 'Noise in cabin', 'status': 'Pending', 'date': '2026-04-02'},
  ];

  void _submitComplaint() async {
    if (_complaintController.text.isEmpty) return;
    
    final message = _complaintController.text;
    
    setState(() {
      _complaints.insert(0, {
        'title': message,
        'status': 'Pending',
        'date': DateTime.now().toIso8601String().split('T')[0],
      });
      _complaintController.clear();
    });

    // Call API: /api/feedback
    appState.submitFeedback(message);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted successfully')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Complaints & Feedback',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New Complaint',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: _complaintController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Describe your issue here...',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitComplaint,
                    child: const Text('Submit Complaint'),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text('Previous Complaints',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _complaints.length,
            itemBuilder: (context, index) {
              final complaint = _complaints[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    complaint['status'] == 'Resolved' ? Icons.check_circle : Icons.pending,
                    color: complaint['status'] == 'Resolved' ? successColor : warningColor,
                  ),
                  title: Text(complaint['title']!),
                  subtitle: Text('Date: ${complaint['date']}'),
                  trailing: Text(
                    complaint['status']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: complaint['status'] == 'Resolved' ? successColor : warningColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
