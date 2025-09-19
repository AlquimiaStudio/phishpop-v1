import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class HistoryScanItemIcon extends StatelessWidget {
  final String scanType;
  final String scanStatus;

  const HistoryScanItemIcon({
    super.key,
    required this.scanType,
    required this.scanStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: getStatusColor(scanStatus).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        getIcon(scanType),
        color: getStatusColor(scanStatus),
        size: 20,
      ),
    );
  }
}
