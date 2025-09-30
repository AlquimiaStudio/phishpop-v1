import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ScreenHeader(
            title: 'Phishing Scanner',
            subtitle: 'Analyze messages and URLs for threats',
            icon: Icons.security,
            message: 'Paste suspicious content below for instant analysis',
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
