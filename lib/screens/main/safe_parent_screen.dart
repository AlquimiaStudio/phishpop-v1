import 'package:flutter/material.dart';

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
          const SizedBox(height: 8),
          InfoHeaderMessage(
            message:
                'Protect yourself and your family from phone scams and fraudulent communications.',
          ),
          const SizedBox(height: 24),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScamLibraryScreen()),
          ),
        ),
        SafeParentFeatureCard(
          title: 'Decision Helper',
          subtitle: 'Is this a scam?',
          icon: Icons.help_outline,
          color: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DecisionHelperScreen()),
          ),
        ),
        SafeParentFeatureCard(
          title: 'Family Mode',
          subtitle: 'Protect loved ones',
          icon: Icons.family_restroom,
          color: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FamilyModeScreen()),
          ),
        ),
        SafeParentFeatureCard(
          title: 'Quick Report',
          subtitle: 'Report scams easily',
          icon: Icons.report_problem,
          color: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuickReportScreen()),
          ),
        ),
      ],
    );
  }
}
