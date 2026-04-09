import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payroll & Payslips',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          // Summary Card
          ModernCard(
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, size: 48, color: primaryColor),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Next Payout Date', style: TextStyle(color: textSecondary)),
                      const Text('April 30, 2026',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('View Salary Structure'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text('Recent Payslips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final months = ['March 2026', 'February 2026', 'January 2026'];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: secondaryColor,
                    child: Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text(months[index]),
                  subtitle: const Text('Status: Generated'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download, color: primaryColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Downloading payslip...')),
                      );
                    },
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
