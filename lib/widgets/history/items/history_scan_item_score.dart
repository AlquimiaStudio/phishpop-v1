import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class HistoryScanItemScore extends StatelessWidget {
  final double score;
  final String status;

  const HistoryScanItemScore({
    super.key,
    required this.score,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${score.toStringAsFixed(0)}%',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: getCardColor(status),
      ),
    );
  }
}
