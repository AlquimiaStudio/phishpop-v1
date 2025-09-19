import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class QrUrlSummaryScreen extends StatelessWidget {
  const QrUrlSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.qr_code_scanner,
          title: 'QR Analysis',
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(
                  title: 'QR Code Results',
                  subtitle: 'Security analysis of scanned QR code',
                  icon: Icons.qr_code,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
