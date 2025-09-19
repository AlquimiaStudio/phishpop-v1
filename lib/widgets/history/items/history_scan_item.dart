import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../widgets.dart';

class HistoryScanItem extends StatelessWidget {
  final ScanHistoryModel scanData;

  const HistoryScanItem({super.key, required this.scanData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: getBoxShadow(context),
        child: Row(
          children: [
            HistoryScanItemIcon(
              scanType: scanData.scanType,
              scanStatus: scanData.status,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HistoryScanItemTitle(title: scanData.title),
                  const SizedBox(height: 4),
                  HistoryScanItemInfo(
                    date: scanData.date,
                    status: scanData.status,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                HistoryScanItemScore(
                  score: scanData.score,
                  status: scanData.status,
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, color: Colors.grey[500], size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
