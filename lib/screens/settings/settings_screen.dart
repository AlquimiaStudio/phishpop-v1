import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final RevenueCatService revenueCat = RevenueCatService();
  final UsageLimitsService usageLimits = UsageLimitsService();

  bool isPremium = false;
  Map<String, UsageStats>? allStats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final premium = await revenueCat.isUserPremium();
      final stats = await usageLimits.getAllUsageStats();

      setState(() {
        isPremium = premium;
        allStats = stats;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToPricing() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PricingScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void navigateToUsageStats() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UsageStatsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.settings_suggest_outlined,
          title: 'Settings',
          useNavigatorPop: true,
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenHeader(
                    title: 'Account Settings',
                    subtitle: 'Manage your profile and preferences',
                    icon: Icons.account_circle,
                    message: 'View and update your account information',
                  ),
                  const SizedBox(height: 24),
                  const UserProfileSection(),
                  const SizedBox(height: 24),
                  SubscriptionStatusCard(
                    subscriptionType: isPremium
                        ? SubscriptionType.premium
                        : SubscriptionType.free,
                    onUpgradePressed: navigateToPricing,
                  ),
                  if (!isLoading && allStats != null) ...[
                    const SizedBox(height: 24),
                    UsageStatsOverview(
                      allStats: allStats!,
                      isPremium: isPremium,
                      onViewDetails: navigateToUsageStats,
                      onUpgrade: navigateToPricing,
                    ),
                  ],
                  const SizedBox(height: 5),
                  const UserInfoCard(),
                  const SizedBox(height: 20),
                  const AccountActionsSection(),
                  const SizedBox(height: 20),
                  const SettingsMenuSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
