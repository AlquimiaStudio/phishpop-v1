import 'package:flutter/material.dart';
import '../../helpers/privacy_security.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.privacy_tip,
          title: 'Privacy & Security',
          useNavigatorPop: true,
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildIntroSection(),
                const SizedBox(height: 16),
                buildDataCollectionSection(),
                const SizedBox(height: 16),
                buildAuthenticationSection(),
                const SizedBox(height: 16),
                buildLocalStorageSection(),
                const SizedBox(height: 16),
                buildThirdPartySection(),
                const SizedBox(height: 16),
                buildSecuritySection(),
                const SizedBox(height: 16),
                buildLegalDisclaimerSection(),
                const SizedBox(height: 16),
                buildContactSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
