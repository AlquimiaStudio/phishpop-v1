import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import 'providers.dart';

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

  void reset() {
    state = QrScanState.idle;
    lastResult = null;
    errorMessage = null;
    isScanning = false;
    notifyListeners();
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

    setState(QrScanState.scanning);
    navigator.pop();

    final String? qrResult = await QrGalleryService.pickAndScanQrFromGallery(
      context,
    );

    if (qrResult != null) {
      lastResult = qrResult;

      processQrFromGallery(qrResult, navigator);
    } else {
      setState(QrScanState.idle);
    }
  }

  void processQrFromGallery(String qrResult, NavigatorState navigator) async {
    try {
      if (isUrl(qrResult)) {
        setState(QrScanState.success);

        navigator.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoadingScreen(
                  icon: Icons.qr_code_scanner,
                  title: 'Analyzing QR Code...',
                  subtitle: 'Please wait while we analyze the QR code URL',
                  screen: QrUrlSummaryScreen(urlToAnalyze: qrResult),
                  urlToAnalyze: qrResult, // Nuevo parámetro para análisis real
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

        final historyProvider = navigator.context.read<HistoryProvider>();
        navigator.context.read<QrUrlProvider>().analyzeQrUrl(
          qrResult,
          historyProvider,
        );
      } else if (isWifi(qrResult)) {
        setState(QrScanState.success);

        navigator.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoadingScreen(
                  icon: Icons.qr_code_scanner,
                  title: 'Analyzing QR Code...',
                  subtitle: 'Please wait while we analyze the QR code WIFI',
                  screen: QrWifiSummaryScreen(wifiContent: qrResult),
                  urlToAnalyze: qrResult, // Nuevo parámetro para análisis real
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

        final historyProvider = navigator.context.read<HistoryProvider>();
        navigator.context.read<QrWifiProvider>().analyzeQrWifi(
          qrResult,
          historyProvider,
        );
      } else {
        setState(QrScanState.unsupported);
        errorMessage = 'QR code type not supported';

        ScaffoldMessenger.of(navigator.context).showSnackBar(
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

  void processQrFromCamera(
    String qrResult,
    BuildContext context,
    NavigatorState navigator,
  ) async {
    lastResult = qrResult;

    try {
      if (isUrl(qrResult)) {
        setState(QrScanState.success);

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoadingScreen(
                  icon: Icons.qr_code_scanner,
                  title: 'Analyzing QR Code...',
                  subtitle: 'Please wait while we analyze the QR code URL',
                  screen: QrUrlSummaryScreen(urlToAnalyze: qrResult),
                  time: 4,
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

        final historyProvider = context.read<HistoryProvider>();
        context.read<QrUrlProvider>().analyzeQrUrl(qrResult, historyProvider);
      } else if (isWifi(qrResult)) {
        setState(QrScanState.success);

        navigator.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoadingScreen(
                  icon: Icons.qr_code_scanner,
                  title: 'Analyzing QR Code...',
                  subtitle: 'Please wait while we analyze the QR code WIFI',
                  screen: QrWifiSummaryScreen(wifiContent: qrResult),
                  urlToAnalyze: qrResult, // Nuevo parámetro para análisis real
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

        final historyProvider = context.read<HistoryProvider>();
        context.read<QrWifiProvider>().analyzeQrWifi(qrResult, historyProvider);
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
