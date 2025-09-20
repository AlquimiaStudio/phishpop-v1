import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

enum QrScanState { idle, scanning, success, error, unsupported }

class QrProvider extends ChangeNotifier {
  QrScanState state = QrScanState.idle;
  String? lastResult;
  String? errorMessage;
  bool isScanning = false;

  void setState(QrScanState newState) {
    state = newState;
    isScanning = newState == QrScanState.scanning;
    if (newState != QrScanState.error && newState != QrScanState.unsupported) {
      errorMessage = null;
    }
    notifyListeners();
  }

  void clearResult() {
    lastResult = null;
    errorMessage = null;
    setState(QrScanState.idle);
  }

  void reset() {
    state = QrScanState.idle;
    lastResult = null;
    errorMessage = null;
    isScanning = false;
    notifyListeners();
  }

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
    setState(QrScanState.scanning);
    Navigator.pop(context);
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

    setState(QrScanState.scanning);
    navigator.pop();

    final String? qrResult = await QrGalleryService.pickAndScanQrFromGallery(
      context,
    );

    if (qrResult != null) {
      lastResult = qrResult;
      processQrFromGallery(qrResult, navigator, scaffoldMessenger);
    } else {
      setState(QrScanState.idle);
    }
  }

  void processQrFromGallery(
    String qrResult,
    NavigatorState navigator,
    ScaffoldMessengerState scaffoldMessenger,
  ) {
    try {
      if (isUrl(qrResult)) {
        setState(QrScanState.success);
        navigator.push(
          MaterialPageRoute(
            builder: (context) => QrUrlSummaryScreen(qrContent: qrResult),
          ),
        );
      } else if (isWifi(qrResult)) {
        setState(QrScanState.success);
        navigator.push(
          MaterialPageRoute(
            builder: (context) => QrWifiSummaryScreen(qrContent: qrResult),
          ),
        );
      } else {
        setState(QrScanState.unsupported);
        errorMessage = 'QR code type not supported';
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('QR code type not supported'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red[300],
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      setState(QrScanState.error);
      errorMessage = e.toString();
    }
  }

  void processQrFromCamera(String qrResult, BuildContext context) {
    lastResult = qrResult;
    try {
      if (isUrl(qrResult)) {
        setState(QrScanState.success);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => QrUrlSummaryScreen(qrContent: qrResult),
          ),
        );
      } else if (isWifi(qrResult)) {
        setState(QrScanState.success);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => QrWifiSummaryScreen(qrContent: qrResult),
          ),
        );
      } else {
        setState(QrScanState.unsupported);
        errorMessage = 'QR code type not supported';
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('QR code type not supported'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red[300],
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      setState(QrScanState.error);
      errorMessage = e.toString();
    }
  }
}
