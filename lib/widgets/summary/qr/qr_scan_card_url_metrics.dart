import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../models/models.dart';
import '../../../theme/theme.dart';

class QrScanCardUrlMetrics extends StatelessWidget {
  final QRUrlResponseModel result;

  const QrScanCardUrlMetrics({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Metrics',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.mediumText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildMetric(
                  context,
                  'Risk Level',
                  result.riskLevel.name.toUpperCase(),
                  _getRiskLevelColor(result.riskLevel),
                  Icons.security,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildMetric(
                  context,
                  'Analysis Score',
                  '${(result.urlAnalysisScore * 100).toInt()}%',
                  _getScoreColor(result.urlAnalysisScore),
                  Icons.analytics,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildMetric(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.mediumText),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getRiskLevelColor(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return AppColors.successColor;
      case RiskLevel.medium:
        return AppColors.warningColor;
      case RiskLevel.high:
        return AppColors.dangerColor;
      case RiskLevel.critical:
        return AppColors.dangerColor;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 0.8) return AppColors.successColor;
    if (score >= 0.6) return AppColors.warningColor;
    return AppColors.dangerColor;
  }
}
