import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';

class StatsEmptyState extends StatelessWidget {
  const StatsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'Security Stats',
            subtitle: 'Monitor your protection metrics',
            icon: Icons.analytics,
          ),
          const SizedBox(height: 40),
          NoResultsMessage(
            icon: Icons.analytics,
            title: 'No statistics available',
            subtitle: 'Start scanning to generate analytics',
          ),
        ],
      ),
    );
  }
}
