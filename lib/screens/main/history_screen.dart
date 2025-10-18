import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isPremium = true;

  @override
  void initState() {
    super.initState();
    checkPremiumStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().initialize();
    });
  }

  Future<void> checkPremiumStatus() async {
    final premium = await RevenueCatService().isUserPremium();
    if (mounted) {
      setState(() {
        isPremium = premium;
      });
    }
  }

  Future<void> onRefresh() async {
    await context.read<HistoryProvider>().refreshHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ScreenHeader(
                  title: 'Scan History',
                  subtitle: historyProvider.hasInitialized
                      ? 'Review your previous threat'
                      : 'Loading your scan history...',
                  icon: Icons.history,
                ),
                const SizedBox(height: 10),
                buildBody(historyProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBody(HistoryProvider historyProvider) {
    if (!isPremium) {
      return const PremiumFeatureCard(
        title: 'Scan History',
        description: 'Track all your scans and access them anytime',
      );
    }

    if (historyProvider.isLoading && !historyProvider.hasInitialized) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (historyProvider.error != null) {
      return NoResultsMessage(
        icon: Icons.error_outline,
        title: 'Unable to load history',
        subtitle: historyProvider.error!,
      );
    }

    if (historyProvider.isEmpty) {
      return NoResultsMessage(
        icon: Icons.history,
        title: 'No scan history yet',
        subtitle:
            'Your analysis results will appear here after you perform scans',
      );
    }

    return HistoryScanList(scanHistory: historyProvider.scanHistory);
  }
}
