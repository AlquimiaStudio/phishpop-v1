import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../utils/utils.dart';
import '../widgets.dart';

class HistoryScanList extends StatelessWidget {
  const HistoryScanList({super.key});

  @override
  Widget build(BuildContext context) {
    final scanHistory = getScanHistoryData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [HistoryScanTitle(totalScans: scanHistory.length)],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scanHistory.length,
          itemBuilder: (context, index) {
            final scan = scanHistory[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: HistoryScanItem(scanData: scan)
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (index * 50).ms)
                  .slideX(begin: 0.2, duration: 300.ms, delay: (index * 50).ms),
            );
          },
        ),
      ],
    );
  }
}
