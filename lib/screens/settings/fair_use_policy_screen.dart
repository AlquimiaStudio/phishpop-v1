import 'package:flutter/material.dart';
import '../../helpers/fair_use_policy.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class FairUsePolicyScreen extends StatelessWidget {
  const FairUsePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.policy,
          title: 'Fair Use Policy',
          useNavigatorPop: true,
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildFairUsePolicyIntro(),
                const SizedBox(height: 16),
                buildUsageLimitsSection(),
                const SizedBox(height: 16),
                buildFreeUserLimitsSection(),
                const SizedBox(height: 16),
                buildWhyLimitsSection(),
                const SizedBox(height: 16),
                buildExceedingLimitsSection(),
                const SizedBox(height: 16),
                buildMonitoringSection(),
                const SizedBox(height: 16),
                buildPolicyChangesSection(),
                const SizedBox(height: 16),
                buildContactSupportSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
