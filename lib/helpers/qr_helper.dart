import 'package:flutter/material.dart';

import '../screens/qr/qr_camera_screen.dart';
import '../screens/screens.dart';
import '../services/qr_gallery_service.dart';
import '../widgets/qr/qr.dart';

void showQrScanModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => QrScanModal(
      onCameraPressed: () => handleCameraQrScan(context),
      onGalleryPressed: () => handleGalleryQrScan(context),
    ),
  );
}

void handleCameraQrScan(BuildContext context) async {
  Navigator.pop(context); // Close modal

  // Navigate to camera screen - no need to wait for result
  // because camera screen handles navigation directly
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const QrCameraScreen()),
  );
}

void handleGalleryQrScan(BuildContext context) async {
  final NavigatorState navigator = Navigator.of(context);
  final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(
    context,
  );
  navigator.pop(); // Close modal first

  final String? qrResult = await QrGalleryService.pickAndScanQrFromGallery(
    context,
  );

  if (qrResult != null) {
    try {
      if (isUrl(qrResult)) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => QrUrlSummaryScreen(qrContent: qrResult),
          ),
        );
      } else if (isWifi(qrResult)) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => QrWifiSummaryScreen(qrContent: qrResult),
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('QR code type not supported'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      // Silent error handling - user will see no navigation if it fails
    }
  }
}

void processQrResult(BuildContext context, String qrResult) {
  try {
    if (isUrl(qrResult)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrUrlSummaryScreen(qrContent: qrResult),
        ),
      );
    } else if (isWifi(qrResult)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrWifiSummaryScreen(qrContent: qrResult),
        ),
      );
    } else {
      // Show error for unsupported QR code type
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('QR code type not supported'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  } catch (e) {
    // Silent error handling
  }
}

bool isUrl(String text) {
  final Uri? uri = Uri.tryParse(text);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}

bool isWifi(String text) {
  return text.toUpperCase().startsWith('WIFI:');
}
