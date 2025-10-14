import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class UsageStatsScreen extends StatefulWidget {
  const UsageStatsScreen({super.key});

  @override
  State<UsageStatsScreen> createState() => _UsageStatsScreenState();
}

class _UsageStatsScreenState extends State<UsageStatsScreen> {
  final UsageLimitsService usageLimits = UsageLimitsService();
  final RevenueCatService revenueCat = RevenueCatService();

  Map<String, UsageStats>? allStats;
  bool isPremium = false;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadUsageStats();
  }

  Future<void> loadUsageStats() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final stats = await usageLimits.getAllUsageStats();
      final premium = await revenueCat.isUserPremium();

      setState(() {
        allStats = stats;
        isPremium = premium;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void navigateToSubscription() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PricingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.analytics,
          title: 'Usage Statistics',
          useNavigatorPop: true,
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : error != null
              ? _buildErrorState()
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Unable to load usage statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error ?? 'Unknown error',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadUsageStats,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (allStats == null || allStats!.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: loadUsageStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildStatusBanner(),
            const SizedBox(height: 24),
            _buildSectionTitle('Scan Usage'),
            const SizedBox(height: 12),
            ...allStats!.entries.map(
              (entry) => UsageLimitCard(stats: entry.value),
            ),
            if (!isPremium) ...[
              const SizedBox(height: 8),
              PremiumUpgradePrompt(
                type: _getPromptType(),
                onUpgrade: navigateToSubscription,
                isDismissible: false,
              ),
            ],
            const SizedBox(height: 24),
            _buildInfoSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insights, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No usage data yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start scanning to see your usage statistics',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    final hasAnyLimit = allStats!.values.any((s) => s.isExceeded);
    final nearAnyLimit = allStats!.values.any((s) => s.isNearLimit);

    Color bannerColor;
    IconData bannerIcon;
    String bannerTitle;
    String bannerMessage;

    if (isPremium) {
      bannerColor = Colors.blue;
      bannerIcon = Icons.star;
      bannerTitle = 'Premium Active';
      bannerMessage = 'You have unlimited access to all scan types';
    } else if (hasAnyLimit) {
      bannerColor = Colors.red;
      bannerIcon = Icons.block;
      bannerTitle = 'Limit Reached';
      bannerMessage =
          'You\'ve reached your limit for some scan types this month';
    } else if (nearAnyLimit) {
      bannerColor = Colors.orange;
      bannerIcon = Icons.warning_amber;
      bannerTitle = 'Approaching Limit';
      bannerMessage = 'You\'re getting close to your monthly limits';
    } else {
      bannerColor = Colors.green;
      bannerIcon = Icons.check_circle;
      bannerTitle = 'All Good';
      bannerMessage = 'You have plenty of scans remaining this month';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: bannerColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(bannerIcon, color: bannerColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bannerTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: bannerColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bannerMessage,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'About Usage Limits',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Usage limits reset on the 1st of each month. Premium users enjoy unlimited scans for all scan types.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FairUsePolicyScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  'Learn more about our Fair Use Policy',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16, color: Colors.blue[700]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PromptType _getPromptType() {
    final hasAnyLimit = allStats!.values.any((s) => s.isExceeded);
    final nearAnyLimit = allStats!.values.any((s) => s.isNearLimit);

    if (hasAnyLimit) return PromptType.limitReached;
    if (nearAnyLimit) return PromptType.nearLimit;
    return PromptType.general;
  }
}
