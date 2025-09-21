import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanQrUrlEmptyState extends StatelessWidget {
  const ScanQrUrlEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'No Results',
            subtitle: 'QR code analysis returned no data',
            icon: Icons.qr_code,
          ).animate().fadeIn().slideY(begin: -0.1),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.mediumText.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.qr_code_2,
                    size: 40,
                    color: AppColors.mediumText,
                  ),
                ).animate().scale(delay: 100.ms),
                const SizedBox(height: 24),
                Text(
                  'No Analysis Data',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.mediumText,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 12),
                Text(
                  'The QR code analysis did not return any results.\nPlease try scanning again.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mediumText,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 32),
                Text(
                  'Pull down to refresh',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mediumText,
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