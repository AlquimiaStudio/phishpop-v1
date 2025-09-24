import 'package:flutter/material.dart';

import '../../widgets.dart';

class ScamReportStepsSection extends StatelessWidget {
  final List<String> reportSteps;

  const ScamReportStepsSection({super.key, required this.reportSteps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeader(title: 'How to Report'),
        const SizedBox(height: 12),
        ...reportSteps.map(
          (step) => ScamListItemRow(
            leading: Icon(
              Icons.report_problem,
              color: theme.colorScheme.tertiary,
              size: 22,
            ),
            title: Text(step, style: theme.textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }
}
