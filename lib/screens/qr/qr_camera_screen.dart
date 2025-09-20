import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../widgets/qr/qr.dart';
import '../summary/qr_url_summary_screen.dart';
import '../summary/qr_wifi_summary_screen.dart';

class QrCameraScreen extends StatefulWidget {
  const QrCameraScreen({super.key});

  @override
  State<QrCameraScreen> createState() => _QrCameraScreenState();
}

class _QrCameraScreenState extends State<QrCameraScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isFlashOn = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    try {
      await controller.start();
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        // Stop the scanner to prevent multiple detections
        controller.stop();

        // Navigate directly to result screen
        _navigateToResult(barcode.rawValue!);
        break;
      }
    }
  }

  void _navigateToResult(String qrResult) {
    if (_isUrl(qrResult)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QrUrlSummaryScreen(qrContent: qrResult),
        ),
      );
    } else if (_isWifi(qrResult)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QrWifiSummaryScreen(qrContent: qrResult),
        ),
      );
    } else {
      // Go back and show error
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('QR code type not supported'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  bool _isUrl(String text) {
    final Uri? uri = Uri.tryParse(text);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool _isWifi(String text) {
    return text.toUpperCase().startsWith('WIFI:');
  }

  void toggleFlash() async {
    await controller.toggleTorch();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          hasError
              ? Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.white, size: 64),
                        const SizedBox(height: 16),
                        const Text(
                          'Camera Error',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please check camera permissions',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : MobileScanner(controller: controller, onDetect: onDetect),
          const QrScannerOverlay(),
          QrTopActions(
            onClose: () => Navigator.of(context).pop(),
            onToggleFlash: toggleFlash,
            isFlashOn: isFlashOn,
          ),
          const QrBottomActions(),
        ],
      ),
    );
  }
}
