import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class HistoryScanItemIcon extends StatelessWidget {
  final String scanType;
  final String scanStatus;
  final String? riskLevel;

  const HistoryScanItemIcon({
    super.key,
    required this.scanType,
    required this.scanStatus,
    this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final color = getRiskLevelColor(riskLevel, scanStatus);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        getIcon(scanType),
        color: color,
        size: 20,
      ),
    );
  }
}
