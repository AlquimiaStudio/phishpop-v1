import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanTextLoadingState extends StatelessWidget {
  const ScanTextLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'Analyzing Text',
            subtitle: 'Scanning for phishing and security threats',
            icon: Icons.security,
          ).animate().fadeIn().slideY(begin: -0.1),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.text_snippet,
                    size: 64,
                    color: AppColors.primaryColor,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1500.ms)
                      .then()
                      .shake(hz: 0.5),
                ).animate().scale(duration: 600.ms),
                const SizedBox(height: 24),
                Text(
                  'Analyzing Text Content',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.mediumText,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 12),
                Text(
                  'Please wait while we check for phishing indicators and security threats...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 32),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}