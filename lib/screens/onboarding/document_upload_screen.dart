import 'package:flutter/material.dart';
import '../../core/api/api_service.dart';
import 'company_policies_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final _apiService = ApiService();
  bool _isLoading = false;

  final Map<String, bool> _uploadedDocs = {
    'NIC / ID Copy': false,
    'Certificates': false,
    'CV / Resume': false,
    'Bank Details': false,
  };

  Future<void> _uploadDoc(String docType) async {
    // Simulate opening File Manager / Explorer
    bool? proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select File'),
        content: Text('Open File Explorer to select $docType?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Select')),
        ],
      ),
    );

    if (proceed != true) return;

    setState(() => _isLoading = true);
    // Simulate API call: /api/onboarding/upload
    final success = await _apiService.uploadDocument(docType, 'selected_file_path.pdf');
    if (success && mounted) {
      setState(() {
        _uploadedDocs[docType] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$docType uploaded successfully')),
      );
    }
    setState(() => _isLoading = false);
  }


  void _next() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CompanyPoliciesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Upload')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Step 3 of 6', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                const Text('Upload Documents', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                if (_isLoading) const LinearProgressIndicator(),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: _uploadedDocs.keys.map((doc) {
                      final isUploaded = _uploadedDocs[doc]!;
                      return Card(
                        child: ListTile(
                          title: Text(doc),
                          trailing: isUploaded
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : ElevatedButton.icon(
                                  onPressed: _isLoading ? null : () => _uploadDoc(doc),
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Upload'),
                                ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _uploadedDocs.values.every((v) => v) ? _next : null,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: const Text('Next'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
