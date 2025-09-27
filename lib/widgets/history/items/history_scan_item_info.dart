import 'package:flutter/material.dart';
import 'package:phishpop/helpers/generals.dart';

class HistoryScanItemInfo extends StatelessWidget {
  final String date;
  final String status;

  const HistoryScanItemInfo({
    super.key,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(date, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: getStatusColor(status).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: getStatusColor(status),
            ),
          ),
        ),
      ],
    );
  }
}
