import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class ScamDetailScreen extends StatelessWidget {
  final ScamScript scamScript;

  const ScamDetailScreen({super.key, required this.scamScript});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          title: scamScript.title,
          icon: Icons.warning_amber,
          returnScreen: ScamLibraryScreen(),
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SingleChildScrollView(
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
                const SizedBox(height: 24),
                ScamReportingWebsitesSection(
                  reportingWebsites: scamScript.reportingWebsites,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
