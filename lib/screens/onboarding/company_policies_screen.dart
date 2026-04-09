import 'package:flutter/material.dart';
import '../../core/api/api_service.dart';
import 'orientation_screen.dart';

class CompanyPoliciesScreen extends StatefulWidget {
  const CompanyPoliciesScreen({super.key});

  @override
  State<CompanyPoliciesScreen> createState() => _CompanyPoliciesScreenState();
}

class _CompanyPoliciesScreenState extends State<CompanyPoliciesScreen> {
  final _apiService = ApiService();
  bool _accepted = false;
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final success = await _apiService.acceptPolicies();
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrientationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Policies')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Step 4 of 6', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                const Text('Company Policies', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const SingleChildScrollView(
                      child: Text(
                        '''Please read and accept the following policies:

1. Code of Conduct
Employees must maintain a professional environment and act ethically.

2. Data Privacy
All company data is confidential and cannot be shared externally.

3. Workplace Safety
Employees must adhere to safety guidelines while on the premises.

4. Leave Policy
All leaves must be approved by the manager at least 2 days prior.''',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('I Accept all Company Policies'),
                  value: _accepted,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (val) {
                    setState(() => _accepted = val ?? false);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _accepted && !_isLoading ? _submit : null,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Next'),
                )
              ],
            ),  
          ),   
        ),    
      ),     
    );      
  }
}
