import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class GuestStatsPrompt extends StatelessWidget {
  const GuestStatsPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: AppColors.primaryColor.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 24),
              Text(
                'Statistics Unavailable',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mediumText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Guest users cannot access statistics. Create a free account to:',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.darkText,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildBenefit(
                icon: Icons.trending_up,
                text: 'Track your security metrics over time',
              ),
              const SizedBox(height: 16),
              _buildBenefit(
                icon: Icons.bar_chart,
                text: 'View detailed threat analytics',
              ),
              const SizedBox(height: 16),
              _buildBenefit(
                icon: Icons.history,
                text: 'Access your complete scan history',
              ),
              const SizedBox(height: 16),
              _buildBenefit(
                icon: Icons.flash_on,
                text: 'Get 3 scans per month (vs 1 for guests)',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Create Free Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mediumText,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
