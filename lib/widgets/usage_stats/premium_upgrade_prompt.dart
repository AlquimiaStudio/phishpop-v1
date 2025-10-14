import 'package:flutter/material.dart';
import '../../theme/theme.dart';

enum PromptType { limitReached, nearLimit, general }

class PremiumUpgradePrompt extends StatelessWidget {
  final PromptType type;
  final String? scanTypeName;
  final int? percentage;
  final VoidCallback? onUpgrade;
  final VoidCallback? onDismiss;
  final bool isDismissible;

  const PremiumUpgradePrompt({
    super.key,
    this.type = PromptType.general,
    this.scanTypeName,
    this.percentage,
    this.onUpgrade,
    this.onDismiss,
    this.isDismissible = true,
  });

  Color get _accentColor {
    switch (type) {
      case PromptType.limitReached:
        return AppColors.dangerColor;
      case PromptType.nearLimit:
        return Colors.orange;
      case PromptType.general:
        return AppColors.primaryColor;
    }
  }

  IconData get _icon {
    switch (type) {
      case PromptType.limitReached:
        return Icons.block;
      case PromptType.nearLimit:
        return Icons.warning_amber;
      case PromptType.general:
        return Icons.star;
    }
  }

  String get _title {
    switch (type) {
      case PromptType.limitReached:
        return 'Limit Reached';
      case PromptType.nearLimit:
        if (percentage != null) {
          return 'You\'ve used $percentage% of your ${scanTypeName ?? 'scans'}';
        }
        return 'Approaching Limit';
      case PromptType.general:
        return 'Upgrade to Premium';
    }
  }

  String get _description {
    switch (type) {
      case PromptType.limitReached:
        return 'You\'ve reached your monthly limit for ${scanTypeName ?? 'this scan type'}. Upgrade to Premium for unlimited access.';
      case PromptType.nearLimit:
        return 'Upgrade now to ensure uninterrupted protection with unlimited scans.';
      case PromptType.general:
        return 'Get unlimited scans and premium features to stay protected.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accentColor.withValues(alpha: 0.1),
            _accentColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: _accentColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _accentColor,
                  ),
                ),
              ),
              if (isDismissible && onDismiss != null)
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600], size: 20),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _description,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeaturesList(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onUpgrade,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upgrade, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Upgrade Now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Unlimited AI scans',
      'Link & email analysis',
      'QR analysis scans',
      'Priority support',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Premium includes:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.successColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    feature,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
