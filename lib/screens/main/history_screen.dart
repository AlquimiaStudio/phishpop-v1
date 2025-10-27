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
    try {
      final premium = await UsageLimitsService().isPremium();
      if (mounted) {
        setState(() {
          isPremium = premium;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isPremium = false;
        });
      }
    }
  }

  Future<void> onRefresh() async {
    await context.read<HistoryProvider>().refreshHistory();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();
    final isGuest = authProvider.isGuest;

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
                buildBody(historyProvider, isGuest),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBody(HistoryProvider historyProvider, bool isGuest) {
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

    return Column(
      children: [
        // Guest History Banner (only for guests)
        if (isGuest) ...[const GuestHistoryBanner()],
        // Premium Banner (only for non-premium registered users)
        if (!isPremium && !isGuest) ...[
          const PremiumBanner(
            icon: Icons.workspace_premium,
            title: 'Unlock Full History',
            subtitle: 'View all your past scans and activity',
          ),
          const SizedBox(height: 30),
        ],
        HistoryScanList(
          scanHistory: historyProvider.scanHistory,
          isPremium: isPremium,
          maxItems: isPremium ? null : 3,
        ),
      ],
    );
  }
}
