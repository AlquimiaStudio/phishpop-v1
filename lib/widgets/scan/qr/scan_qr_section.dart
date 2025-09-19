import 'package:flutter/material.dart';

import '../../widgets.dart';

class ScanQrSection extends StatelessWidget {
  const ScanQrSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScanTitle(title: 'QR Code Scanner', icon: Icons.qr_code_scanner),
        const SizedBox(height: 20),
        ScanQrButton(),
      ],
    );
  }
}
