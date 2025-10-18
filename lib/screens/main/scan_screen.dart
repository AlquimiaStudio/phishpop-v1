import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../../services/services.dart';

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
    final premium = await RevenueCatService().isUserPremium();
    if (mounted) {
      setState(() {
        isPremium = premium;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (!isPremium) ...[
            const PremiumBanner(
              icon: Icons.workspace_premium,
              title: 'Unlimited Scans',
              subtitle: 'Upgrade to scan as much as you want',
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
