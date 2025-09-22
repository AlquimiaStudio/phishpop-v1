import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().initialize();
    });
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
                      ? 'Review your previous threat analysis'
                      : 'Loading your scan history...',
                  icon: Icons.history,
                ),
                const SizedBox(height: 10),
                _buildBody(historyProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(HistoryProvider historyProvider) {
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
