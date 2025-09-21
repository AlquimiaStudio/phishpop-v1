import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../theme/theme.dart';
import '../widgets.dart';

class ScanQrButton extends StatelessWidget {
  const ScanQrButton({super.key});

  void showQrScanModal(BuildContext context) {
    final qrProvider = context.read<QrProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => QrScanModal(
        onCameraPressed: () => qrProvider.handleCameraQrScan(modalContext),
        onGalleryPressed: () => qrProvider.handleGalleryQrScan(modalContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton.icon(
        onPressed: () => showQrScanModal(context),
        icon: Icon(
          Icons.qr_code_scanner,
          size: 20,
          color: AppColors.primaryColor,
        ),
        label: Text(
          'Scan QR Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          side: BorderSide(color: AppColors.primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.05),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
