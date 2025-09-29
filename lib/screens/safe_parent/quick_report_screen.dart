import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/helpers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class QuickReportScreen extends StatefulWidget {
  const QuickReportScreen({super.key});

  @override
  State<QuickReportScreen> createState() => _QuickReportScreenState();
}

class _QuickReportScreenState extends State<QuickReportScreen> {
  final reportFormKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String selectedScamType = '';
  bool isGeneratingReport = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void clearFormFields() {
    setState(() {
      selectedScamType = '';
      descriptionController.clear();
      phoneNumberController.clear();
    });
  }

  Future<void> copyReportToClipboard() async {
    if (!(reportFormKey.currentState?.validate() ?? false)) return;

    setState(() {
      isGeneratingReport = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final report = generateScamReport(
      scamType: selectedScamType,
      description: descriptionController.text.trim(),
      phoneNumber: phoneNumberController.text.trim().isEmpty
          ? null
          : phoneNumberController.text.trim(),
    );

    clearFormFields();
    reportFormKey.currentState?.reset();

    await Clipboard.setData(ClipboardData(text: report));

    setState(() {
      isGeneratingReport = false;
    });

    if (mounted) {
      GlobalSnackBar.showSuccess(
        context,
        'Report copied to clipboard! You can now paste it in emails or forms.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const SecondaryAppbar(
          title: 'Quick Report',
          icon: Icons.report_problem,
          returnScreen: HomeScreen(initialIndex: 3),
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const InfoHeaderMessage(
                    message:
                        'Generate a detailed scam report to share with authorities and agencies.',
                  ),
                  const SizedBox(height: 24),

                  ReportFormFields(
                    formKey: reportFormKey,
                    selectedScamType: selectedScamType,
                    descriptionController: descriptionController,
                    phoneNumberController: phoneNumberController,
                    onScamTypeChanged: (value) {
                      setState(() {
                        selectedScamType = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  ReportGenerateButton(
                    isGenerating: isGeneratingReport,
                    onPressed: copyReportToClipboard,
                  ),
                  const SizedBox(height: 24),

                  const ReportInfoCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
