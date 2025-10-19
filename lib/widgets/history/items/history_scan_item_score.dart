import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class HistoryScanItemScore extends StatelessWidget {
  final double score;
  final String status;
  final String? riskLevel;

  const HistoryScanItemScore({
    super.key,
    required this.score,
    required this.status,
    this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(score * 100).toStringAsFixed(0)}%',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: getRiskLevelColor(riskLevel, status),
      ),
    );
  }
}
