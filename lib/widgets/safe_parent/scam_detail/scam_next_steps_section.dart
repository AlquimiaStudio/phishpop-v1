import 'package:flutter/material.dart';

import '../../widgets.dart';

class ScamNextStepsSection extends StatelessWidget {
  final List<String> nextSteps;

  const ScamNextStepsSection({super.key, required this.nextSteps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeader(title: 'Next Steps'),
        const SizedBox(height: 12),
        ...nextSteps.map(
          (step) => ScamListItemRow(
            leading: Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            title: Text(step, style: theme.textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }
}
