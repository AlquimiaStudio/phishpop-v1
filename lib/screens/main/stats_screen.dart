import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => StatsScreenState();
}

class StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadStats();
    });
  }

  Future<void> loadStats() async {
    final historyProvider = context.read<HistoryProvider>();
    final statsProvider = context.read<StatsProvider>();

    await historyProvider.initialize();
    await statsProvider.loadStats(historyProvider.scanHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StatsProvider, HistoryProvider>(
      builder: (context, statsProvider, historyProvider, child) {
        if (statsProvider.isLoading || historyProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (statsProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading statistics',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  statsProvider.error!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: loadStats,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (historyProvider.isEmpty) {
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
                const SizedBox(height: 24),
                NoResultsMessage(
                  icon: Icons.analytics,
                  title: 'No statistics available',
                  subtitle: 'Start scanning to generate analytics',
                ),
              ],
            ),
          );
        }

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
              ScanTypesChart(
                scanTypeData: statsProvider.scanTypeDistribution,
              ),
              const SizedBox(height: 16),
              TopThreatsList(
                topThreats: statsProvider.topThreats,
              ),
            ],
          ),
        );
      },
    );
  }
}
