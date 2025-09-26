import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../screens/screens.dart';
import '../widgets.dart';

class SafeParentGrid extends StatelessWidget {
  const SafeParentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.98,
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
