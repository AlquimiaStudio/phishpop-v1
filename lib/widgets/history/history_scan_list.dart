import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../theme/theme.dart';
import '../widgets.dart';

class HistoryScanList extends StatelessWidget {
  final List<ScanHistoryModel> scanHistory;

  const HistoryScanList({super.key, required this.scanHistory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HistoryScanTitle(totalScans: scanHistory.length),
            if (scanHistory.isNotEmpty)
              Consumer<HistoryProvider>(
                builder: (context, historyProvider, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.dangerColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.dangerColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _showClearHistoryDialog(context, historyProvider),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: AppColors.dangerColor,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Clear All',
                                style: AppTextStyles.smallButtonText.copyWith(
                                  fontSize: 12,
                                  color: AppColors.dangerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
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
              child: Dismissible(
                key: Key(scan.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                onDismissed: (direction) {
                  context.read<HistoryProvider>().deleteScan(scan.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Scan deleted'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: HistoryScanItem(scanData: scan)
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (index * 50).ms)
                    .slideX(
                      begin: 0.2,
                      duration: 300.ms,
                      delay: (index * 50).ms,
                    ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showClearHistoryDialog(
    BuildContext context,
    HistoryProvider historyProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All History'),
          content: const Text(
            'Are you sure you want to delete all scan history? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                historyProvider.clearAllHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All scan history cleared'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}
