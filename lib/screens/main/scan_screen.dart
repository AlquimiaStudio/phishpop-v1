import 'package:flutter/material.dart';
import 'package:phishpop/theme/app_colors.dart';

import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';
import '../../services/services.dart';
import '../screens.dart';

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
        : 'Upgrade to Premium for unlimited scans and advanced protection';

    final messageColor = isPremium
        ? AppColors.primaryColor
        : AppColors.warningColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ScreenHeader(
            title: 'Phishing Scanner',
            subtitle: 'Analyze messages and URLs for threats',
            icon: Icons.security,
            message: message,
            messageColor: messageColor,
            onActionPressed: isPremium
                ? null
                : () {
                    navigationWithoutAnimation(context, const PricingScreen());
                  },
            actionLabel: isPremium ? null : 'Upgrade to Premium',
          ),
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
