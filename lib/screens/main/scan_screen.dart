import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../../services/services.dart';
import '../../providers/providers.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isPremium = true;

  @override
  void initState() {
    super.initState();
    checkPremiumStatus();
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

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();
    final isGuest = authProvider.isGuest;

    final message = isPremium
        ? 'Paste suspicious content below for instant analysis'
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ScreenHeader(
            title: 'Phishing Scanner',
            subtitle: 'Analyze messages and URLs for threats',
            icon: Icons.security,
            message: message,
          ),

          // Guest Mode Banner (only for guests)
          if (isGuest) ...[
            const SizedBox(height: 16),
            const GuestModeBanner(),
            const SizedBox(height: 12),
            const GuestUpgradeBanner(),
          ],

          // Premium Banner (only for non-premium registered users)
          if (!isPremium && !isGuest) ...[
            const PremiumBanner(
              icon: Icons.workspace_premium,
              title: 'Premium AI Scans',
              subtitle: 'Upgrade to enable AI-powered real-time scans',
            ),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 24),
          ScanTextSection(),
          const SizedBox(height: 24),
          ScanUrlSection(),
          const SizedBox(height: 26),
          ScanQrSection(),
          const SizedBox(height: 40),
          const DisclaimerMessage(
            message:
                'Security analysis results are for informational purposes only. PhishPop cannot guarantee 100% accuracy in threat detection. Always exercise caution and verify suspicious content through multiple sources before taking action.',
          ),
        ],
      ),
    );
  }
}
