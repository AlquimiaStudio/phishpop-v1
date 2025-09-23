import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../widgets.dart';

class StatsContent extends StatelessWidget {
  const StatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsProvider>(
      builder: (context, statsProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: 'Security Stats',
                subtitle: 'Monitor your protection metrics',
                icon: Icons.analytics,
              ),

              if (statsProvider.totalScans != 0) const StatsActionButtons(),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  TotalScansCard(totalScans: statsProvider.totalScans),
                  ThreatsDetectedCard(
                    threatsData: statsProvider.threatsDetected,
                  ),
                  ProtectionLevelCard(
                    protectionData: statsProvider.protectionLevel,
                  ),
                  LastActivityCard(activityData: statsProvider.lastActivity),
                ],
              ),
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
          ),
        );
      },
    );
  }
}
