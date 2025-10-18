import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../screens/screens.dart';
import '../../theme/theme.dart';
import '../widgets.dart';

class HistoryScanList extends StatelessWidget {
  final List<ScanHistoryModel> scanHistory;
  final bool isPremium;
  final int? maxItems;

  const HistoryScanList({
    super.key,
    required this.scanHistory,
    this.isPremium = true,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    final displayedScans = maxItems != null && scanHistory.length > maxItems!
        ? scanHistory.take(maxItems!).toList()
        : scanHistory;
    final hasMoreScans = maxItems != null && scanHistory.length > maxItems!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HistoryScanTitle(totalScans: scanHistory.length),
            if (scanHistory.isNotEmpty && isPremium)
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
        if (scanHistory.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2, left: 7),
            child: Text(
              'Swipe left to delete',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedScans.length,
          itemBuilder: (context, index) {
            final scan = displayedScans[index];
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
        if (hasMoreScans) buildLockedOverlay(context),
      ],
    );
  }

  Widget buildLockedOverlay(BuildContext context) {
    final moreScans = scanHistory.length - maxItems!;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.03),
            AppColors.warningColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warningColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            navigationWithoutAnimation(context, const PricingScreen());
          },
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Icon(
                  Icons.auto_awesome,
                  size: 120,
                  color: AppColors.warningColor.withValues(alpha: 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warningColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        size: 28,
                        color: AppColors.warningColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+$moreScans ${moreScans == 1 ? 'scan' : 'scans'} locked',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Unlock your complete scan history',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.warningColor.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
