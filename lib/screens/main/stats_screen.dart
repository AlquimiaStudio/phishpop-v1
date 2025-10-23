import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => StatsScreenState();
}

class StatsScreenState extends State<StatsScreen> {
  bool isPremium = true;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    checkUserStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isGuest) {
        loadStats();
      }
    });
  }

  Future<void> checkUserStatus() async {
    final authProvider = context.read<AppAuthProvider>();
    final premium = await RevenueCatService().isUserPremium();

    if (mounted) {
      setState(() {
        isGuest = authProvider.isGuest;
        isPremium = premium;
      });
    }
  }

  Future<void> loadStats() async {
    final historyProvider = context.read<HistoryProvider>();
    final statsProvider = context.read<StatsProvider>();

    await historyProvider.initialize();
    await statsProvider.loadStats(historyProvider.scanHistory);
  }

  @override
  Widget build(BuildContext context) {
    // Guest users see a signup prompt instead of stats
    if (isGuest) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ScreenHeader(
              title: 'Security Stats',
              subtitle: 'Monitor your protection metrics',
              icon: Icons.analytics,
            ),
            const SizedBox(height: 40),
            GuestStatsPrompt(),
          ],
        ),
      );
    }

    return Consumer2<StatsProvider, HistoryProvider>(
      builder: (context, statsProvider, historyProvider, child) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ScreenHeader(
                title: 'Security Stats',
                subtitle: 'Monitor your protection metrics',
                icon: Icons.analytics,
              ),
              const SizedBox(height: 10),
              builBody(statsProvider, historyProvider, loadStats),
            ],
          ),
        );
      },
    );
  }

  Widget builBody(
    StatsProvider statsProvider,
    HistoryProvider historyProvider,
    VoidCallback loadStats,
  ) {
    if (statsProvider.isLoading || historyProvider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (statsProvider.error != null) {
      return StatsErrorCard(
        errorMessage: statsProvider.error!,
        onRetry: loadStats,
      );
    }

    if (statsProvider.totalScans == 0) {
      return NoResultsMessage(
        icon: Icons.analytics,
        title: 'No statistics available',
        subtitle: 'Start scanning to generate analytics',
      );
    }

    return Column(
      children: [
        if (!isPremium) ...[
          const PremiumBanner(
            icon: Icons.analytics,
            title: 'Advanced Analytics',
            subtitle: 'Unlock detailed charts and insights',
          ),
          const SizedBox(height: 30),
        ],
        StatsContent(isPremium: isPremium),
      ],
    );
  }
}
