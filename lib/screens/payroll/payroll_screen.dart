import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Finance Protocols', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        const SizedBox(height: 32),
        
        // Summary Card
        ModernCard(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: successColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.account_balance_wallet_outlined, size: 32, color: successColor),
              ),
              const SizedBox(width: 24),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEXT DISBURSEMENT CYCLE', style: TextStyle(color: textSecondary, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w900)),
                    SizedBox(height: 4),
                    Text('APRIL 30, 2026', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Design Structure'),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 48),
        const Text('Transaction Ledger', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final months = ['MARCH 2026', 'FEBRUARY 2026', 'JANUARY 2026'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ModernCard(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long_outlined, color: textSecondary, size: 20),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(months[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                          const Text('STATUS: AUDITED & GENERATED', style: TextStyle(color: successColor, fontSize: 10, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.file_download_outlined, color: primaryColor, size: 20),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Initializing secure file transfer...')),
                        );
                      },
                    ),
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

