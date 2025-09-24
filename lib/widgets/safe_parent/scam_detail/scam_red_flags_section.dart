import 'package:flutter/material.dart';

import '../../widgets.dart';

class ScamRedFlagsSection extends StatelessWidget {
  final List<String> redFlags;

  const ScamRedFlagsSection({super.key, required this.redFlags});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeader(title: 'Red Flags'),
        const SizedBox(height: 12),
        ...redFlags.map(
          (flag) => ScamListItemRow(
            leading: Icon(
              Icons.warning_amber_rounded,
              color: theme.colorScheme.error,
              size: 22,
            ),
            title: Text(
              flag,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
