import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class QrWifiSummaryScreen extends StatelessWidget {
  const QrWifiSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.wifi,
          title: 'WiFi Analysis',
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(
                  title: 'WiFi Network Analysis',
                  subtitle: 'Security assessment of WiFi credentials',
                  icon: Icons.wifi_protected_setup,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
