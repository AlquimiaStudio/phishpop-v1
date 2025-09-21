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
              child: MetricCard(
                title: 'Text Analysis',
                value: '${(result.normalizedScore! * 100).round()}%',
                icon: Icons.text_fields,
                color: getCardColor(result.result),
              ),
            ),
            if (result.normalizedScore != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: 'Risk Level',
                  value: result.riskLevel.capitalize(),
                  icon: Icons.warning_outlined,
                  color: getCardColor(result.result),
                ),
              ),
            ],
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }
}
