import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';

class ScamDetailScreen extends StatelessWidget {
  final ScamScript scamScript;

  const ScamDetailScreen({super.key, required this.scamScript});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: SecondaryAppbar(
        title: scamScript.title,
        icon: Icons.warning_amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScamRedFlagsSection(redFlags: scamScript.redFlags),
            const SizedBox(height: 24),
            ScamSafeResponseSection(safeResponse: scamScript.safeResponse),
            const SizedBox(height: 24),
            ScamNextStepsSection(nextSteps: scamScript.nextSteps),
            const SizedBox(height: 24),
            ScamOfficialNumbersSection(
              officialNumbers: scamScript.officialNumbers,
            ),
            const SizedBox(height: 24),
            ScamReportStepsSection(reportSteps: scamScript.reportSteps),
          ],
        ),
      ),
    );
  }
}
