import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

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
          const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          _buildFeaturesGrid(context),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        SafeParentFeatureCard(
          title: 'Scam Library',
          subtitle: 'Identify common scams',
          icon: Icons.library_books,
          color: Colors.red,
          onTap: () => navigationWithoutAnimation(context, ScamLibraryScreen()),
        ),
        SafeParentFeatureCard(
          title: 'Decision Helper',
          subtitle: 'Is this a scam?',
          icon: Icons.help_outline,
          color: Colors.orange,
          onTap: () =>
              navigationWithoutAnimation(context, DecisionHelperScreen()),
        ),
        SafeParentFeatureCard(
          title: 'Family Mode',
          subtitle: 'Protect loved ones',
          icon: Icons.family_restroom,
          color: Colors.green,
          onTap: () => navigationWithoutAnimation(context, FamilyModeScreen()),
        ),
        SafeParentFeatureCard(
          title: 'Quick Report',
          subtitle: 'Report scams easily',
          icon: Icons.report_problem,
          color: Colors.blue,
          onTap: () => navigationWithoutAnimation(context, QuickReportScreen()),
        ),
      ],
    );
  }
}
