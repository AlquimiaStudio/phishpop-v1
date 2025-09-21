import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../models/models.dart';
import '../../widgets.dart';

class ScanQrUrlResultState extends StatelessWidget {
  final QRUrlResponseModel analysisResult;
  const ScanQrUrlResultState({super.key, required this.analysisResult});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'QR Code Security Check',
            subtitle: 'Safety analysis of the scanned QR code',
            icon: Icons.qr_code_scanner,
          ).animate().fadeIn().slideY(begin: -0.1),
          const SizedBox(height: 24),
          QrUrlResultCard(
            result: analysisResult,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }
}