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
          return StatsErrorCard(
            errorMessage: statsProvider.error!,
            onRetry: loadStats,
          );
        }

        if (statsProvider.totalScans == 0) {
          return const StatsEmptyState();
        }

        return const StatsContent();
      },
    );
  }
}
