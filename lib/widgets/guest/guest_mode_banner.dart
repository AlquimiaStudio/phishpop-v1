import 'package:flutter/material.dart';

import '../../services/services.dart';
import '../../theme/theme.dart';

class GuestModeBanner extends StatefulWidget {
  const GuestModeBanner({super.key});

  @override
  State<GuestModeBanner> createState() => _GuestModeBannerState();
}

class _GuestModeBannerState extends State<GuestModeBanner> {
  int scansUsed = 0;
  int scanLimit = 3;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsageStats();
  }

  Future<void> _loadUsageStats() async {
    try {
      final usageLimits = UsageLimitsService();
      final stats = await usageLimits.getUsageStats('total');

      if (mounted) {
        setState(() {
          scansUsed = stats?.currentCount ?? 0;
          scanLimit = stats?.limit ?? 3;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Color get _progressColor {
    final percentage = scansUsed / scanLimit;
    if (percentage >= 1.0) return Colors.red.shade400;
    if (percentage >= 0.66) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: AppColors.primaryColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Guest Mode',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkText,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: scansUsed / scanLimit,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$scansUsed/$scanLimit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            scansUsed >= scanLimit
                ? 'Limit reached. Create account for 7 scans/month'
                : '${scanLimit - scansUsed} scans remaining this month',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkText.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
