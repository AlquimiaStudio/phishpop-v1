import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import '../../helpers/generals.dart';

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

              Center(
                child: OutlinedButton(
                  onPressed: () => showExplanationModal(
                    context,
                    getStatsExplanations,
                    customTitle: 'Understanding Your Security Stats',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: BorderSide(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Explain my stats'),
                      const SizedBox(width: 8),
                      Icon(Icons.help_outline, size: 18),
                    ],
                  ),
                ),
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

List<Map<String, dynamic>> getStatsExplanations() {
  return [
    {
      'title': 'Total Scans',
      'icon': Icons.analytics,
      'explanation':
          'Shows the total number of security scans you have performed across all types (URLs, text, QR codes, and WiFi networks).',
    },
    {
      'title': 'Threats Detected',
      'icon': Icons.warning,
      'explanation':
          'Displays the number and percentage of scans that identified potential security threats or suspicious content.',
    },
    {
      'title': 'Protection Level',
      'icon': Icons.shield,
      'explanation':
          'Your overall security score based on scan results. Higher scores indicate better protection and fewer security risks.',
    },
    {
      'title': 'Last Activity',
      'icon': Icons.schedule,
      'explanation':
          'Shows when you last performed a security scan and what type of scan it was.',
    },
    {
      'title': 'Confidence Score',
      'icon': Icons.verified,
      'explanation':
          'Average confidence level of our security analysis. Higher scores indicate more reliable threat detection.',
    },
    {
      'title': 'Security Classification',
      'icon': Icons.bar_chart,
      'explanation':
          'Bar chart showing the distribution of scan results: Safe (no threats), Suspicious (potential risks), and Unsafe (confirmed threats).',
    },
    {
      'title': 'Scan Types Distribution',
      'icon': Icons.pie_chart,
      'explanation':
          'Pie chart displaying the breakdown of different types of scans you have performed (URL, Text, QR Code, WiFi).',
    },
    {
      'title': 'Top Security Issues',
      'icon': Icons.list,
      'explanation':
          'Lists the most frequently detected security problems in your scans, ranked by occurrence frequency.',
    },
  ];
}
