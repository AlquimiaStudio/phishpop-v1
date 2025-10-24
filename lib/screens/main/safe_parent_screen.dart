import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../services/services.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

class SafeParentScreen extends StatefulWidget {
  const SafeParentScreen({super.key});

  @override
  State<SafeParentScreen> createState() => _SafeParentScreenState();
}

class _SafeParentScreenState extends State<SafeParentScreen> {
  bool isUserPremium = false;
  final revenueCatService = RevenueCatService();

  @override
  void initState() {
    super.initState();
    checkPremiumStatus();
  }

  Future<void> checkPremiumStatus() async {
    final isPremium = await revenueCatService.isUserPremium();
    if (mounted) {
      setState(() {
        isUserPremium = isPremium;
      });
    }
  }

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
                'Protect yourself and your family from text scams and fraudulent communications.',
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
          if (!isUserPremium) const PremiumBanner(),
        ],
      ),
    );
  }
}
