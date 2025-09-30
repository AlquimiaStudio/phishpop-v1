import 'package:flutter/material.dart';
import '../../theme/theme.dart';

enum SubscriptionType { free, premium }

class SubscriptionStatusCard extends StatelessWidget {
  final SubscriptionType subscriptionType;
  final VoidCallback? onUpgradePressed;

  const SubscriptionStatusCard({
    super.key,
    this.subscriptionType = SubscriptionType.free,
    this.onUpgradePressed,
  });

  bool get isPremium => subscriptionType == SubscriptionType.premium;

  Color get _primaryColor =>
      isPremium ? AppColors.primaryColor : Colors.grey[600]!;
  Color get _backgroundColor => isPremium
      ? AppColors.primaryColor.withValues(alpha: 0.1)
      : Colors.grey[100]!;
  IconData get _statusIcon => isPremium ? Icons.star : Icons.person;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_statusIcon, color: _primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isPremium ? 'Premium' : 'Free',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                        if (isPremium) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubscriptionDescription(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeaturesList(),
          if (!isPremium) ...[
            const SizedBox(height: 16),
            _buildUpgradeButton(),
          ],
        ],
      ),
    );
  }

  String _getSubscriptionDescription() {
    return isPremium
        ? 'Enjoy unlimited scans and premium features'
        : 'Limited features with basic protection';
  }

  Widget _buildFeaturesList() {
    final features = isPremium
        ? [
            'Unlimited scans',
            'Advanced threat detection',
            'Priority support',
            'Ad-free experience',
          ]
        : ['Basic scans (limited)', 'Standard protection', 'Community support'];

    return Column(
      children: features.map((feature) => _buildFeatureItem(feature)).toList(),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isPremium ? Icons.check_circle : Icons.circle_outlined,
            color: isPremium ? AppColors.successColor : Colors.grey[500],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onUpgradePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upgrade, size: 18),
            const SizedBox(width: 8),
            Text(
              'Upgrade to Premium',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
