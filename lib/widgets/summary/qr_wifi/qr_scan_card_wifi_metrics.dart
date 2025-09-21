import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class QrScanCardWifiMetrics extends StatelessWidget {
  final QrWifiResponse result;

  const QrScanCardWifiMetrics({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Metrics',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.mediumText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'Security Score',
                value: '${(result.securityScore * 100).toInt()}%',
                icon: Icons.shield,
                color: getCardColor(result.result.name),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                title: 'Risk Level',
                value: result.riskLevel.name.capitalize(),
                icon: Icons.warning,
                color: _getRiskColor(result.riskLevel),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Color _getRiskColor(WifiRiskLevel riskLevel) {
    switch (riskLevel) {
      case WifiRiskLevel.low:
        return AppColors.successColor;
      case WifiRiskLevel.medium:
        return AppColors.warningColor;
      case WifiRiskLevel.high:
        return AppColors.dangerColor;
      case WifiRiskLevel.critical:
        return AppColors.dangerColor;
    }
  }
}
