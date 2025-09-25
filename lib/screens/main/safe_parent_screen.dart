import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

class SafeParentScreen extends StatelessWidget {
  const SafeParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleHeader(title: 'Safe Parent'),
          const SizedBox(height: 16),
          InfoHeaderMessage(
            message:
                'Protect yourself and your family from phone scams and fraudulent communications.',
          ),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => showExplanationModal(
                context,
                getSafeParentModulesExplanations,
              ),
              icon: Icon(Icons.help_outline, size: 18),
              label: Text('What does this mean?'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          SafeParentGrid(),
        ],
      ),
    );
  }
}
