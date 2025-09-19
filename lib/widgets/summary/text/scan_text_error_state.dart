import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanTextErrorState extends StatelessWidget {
  final String error;
  final VoidCallback refreshData;

  const ScanTextErrorState({
    super.key,
    required this.error,
    required this.refreshData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'Text Analysis Error',
            subtitle: 'Something went wrong during analysis',
            icon: Icons.error_outline,
          ).animate().fadeIn().slideY(begin: -0.1),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.dangerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.dangerColor,
                  ),
                ).animate().scale(duration: 600.ms),
                const SizedBox(height: 24),
                Text(
                  'Analysis Failed',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.dangerColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 12),
                Text(
                  error,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: refreshData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Analysis'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}