import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';

class QuickReportScreen extends StatefulWidget {
  const QuickReportScreen({super.key});

  @override
  State<QuickReportScreen> createState() => _QuickReportScreenState();
}

class _QuickReportScreenState extends State<QuickReportScreen> {
  final _reportFormKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String _selectedScamType = '';
  bool _isGeneratingReport = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _copyReportToClipboard() async {
    if (!(_reportFormKey.currentState?.validate() ?? false)) return;
    
    setState(() {
      _isGeneratingReport = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    
    final report = generateScamReport(
      scamType: _selectedScamType,
      description: _descriptionController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim().isEmpty 
          ? null 
          : _phoneNumberController.text.trim(),
    );
    
    await Clipboard.setData(ClipboardData(text: report));
    
    setState(() {
      _isGeneratingReport = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report copied to clipboard! You can now paste it in emails or forms.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const SecondaryAppbar(
        title: 'Quick Report',
        icon: Icons.report_problem,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoHeaderMessage(
                message: 'Generate a detailed scam report to share with authorities and agencies.',
              ),
              const SizedBox(height: 24),
              
              ReportFormFields(
                formKey: _reportFormKey,
                selectedScamType: _selectedScamType,
                descriptionController: _descriptionController,
                phoneNumberController: _phoneNumberController,
                onScamTypeChanged: (value) {
                  setState(() {
                    _selectedScamType = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 32),

              ReportGenerateButton(
                isGenerating: _isGeneratingReport,
                onPressed: _copyReportToClipboard,
              ),
              const SizedBox(height: 24),

              const ReportInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}