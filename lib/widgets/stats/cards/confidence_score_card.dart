import 'package:flutter/material.dart';

import '../../widgets.dart';

class ConfidenceScoreCard extends StatelessWidget {
  final double confidenceScore;

  const ConfidenceScoreCard({super.key, required this.confidenceScore});

  Color _getConfidenceColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getConfidenceText(double score) {
    if (score >= 80) return 'High';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Low';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getConfidenceColor(confidenceScore);
    final confidenceText = _getConfidenceText(confidenceScore);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.verified, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confidence Score',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      confidenceText,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${confidenceScore.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                StatProgressBar(
                  value: confidenceScore / 100,
                  color: color,
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
