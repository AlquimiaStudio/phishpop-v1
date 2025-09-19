import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanTextMetrics extends StatelessWidget {
  final ITextResponse result;

  const ScanTextMetrics({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfidenceScoreBar(
          confidenceScore: result.confidenceScore,
          result: result.result,
          getDescription: getTextConfidenceDescription,
        ),
        const SizedBox(height: 16),
        _buildAdditionalMetrics(context),
      ],
    );
  }

  Widget _buildAdditionalMetrics(BuildContext context) {
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
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'Text Analysis',
                '${(result.normalizedScore! * 100).round()}%',
                Icons.text_fields,
                getCardColor(result.result),
              ),
            ),
            if (result.normalizedScore != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Risk Level',
                  result.riskLevel.capitalize(),
                  Icons.warning_outlined,
                  getCardColor(result.result),
                ),
              ),
            ],
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
