import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanTextEmptyState extends StatelessWidget {
  const ScanTextEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'Text Analysis',
            subtitle: 'No analysis data available',
            icon: Icons.message,
          ).animate().fadeIn().slideY(begin: -0.1),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.lightText.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.text_snippet_outlined,
                    size: 64,
                    color: AppColors.lightText,
                  ),
                ).animate().scale(duration: 600.ms),
                const SizedBox(height: 24),
                Text(
                  'No Analysis Available',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.mediumText,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 12),
                Text(
                  'Start by analyzing a text message or email for phishing detection.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}