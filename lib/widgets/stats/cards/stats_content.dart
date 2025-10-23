import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../../providers/providers.dart';
import '../../../screens/screens.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class StatsContent extends StatelessWidget {
  final bool isPremium;

  const StatsContent({super.key, this.isPremium = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsProvider>(
      builder: (context, statsProvider, child) {
        return Column(
          children: [
            if (statsProvider.totalScans != 0)
              StatsActionButtons(isPremium: isPremium),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                TotalScansCard(totalScans: statsProvider.totalScans),
                ThreatsDetectedCard(threatsData: statsProvider.threatsDetected),
                ProtectionLevelCard(
                  protectionData: statsProvider.protectionLevel,
                ),
                LastActivityCard(activityData: statsProvider.lastActivity),
              ],
            ),
            if (isPremium) ...[
              const SizedBox(height: 16),
              ConfidenceScoreCard(
                confidenceScore: statsProvider.averageConfidence,
              ),
              const SizedBox(height: 24),
              SecurityDistributionChart(
                classificationData: statsProvider.classificationDistribution,
              ),
              const SizedBox(height: 16),
              ScanTypesChart(scanTypeData: statsProvider.scanTypeDistribution),
              const SizedBox(height: 16),
              TopThreatsList(topThreats: statsProvider.topThreats),
            ],
            if (!isPremium) buildLockedStatsOverlay(context),
          ],
        );
      },
    );
  }

  Widget buildLockedStatsOverlay(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.insights,
                  size: 48,
                  color: AppColors.warningColor.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  '4 Advanced Analytics Locked',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Confidence Score • Distribution Charts\nScan Types Analysis • Top Threats',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
