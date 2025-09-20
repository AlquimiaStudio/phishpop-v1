import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'qr_option_button.dart';

class QrScanModal extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const QrScanModal({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.qr_code_scanner, color: AppColors.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Scan QR Code',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          QrOptionButton(
            icon: Icons.camera_alt,
            title: 'Use Camera',
            subtitle: 'Scan QR code with camera',
            onPressed: onCameraPressed,
          ),
          const SizedBox(height: 16),
          QrOptionButton(
            icon: Icons.photo_library,
            title: 'Choose from Gallery',
            subtitle: 'Select image with QR code',
            onPressed: onGalleryPressed,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}