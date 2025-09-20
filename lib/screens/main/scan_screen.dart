import 'dart:io';

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
          SizedBox(height: Platform.isIOS ? 140 : 60),
        ],
      ),
    );
  }
}
