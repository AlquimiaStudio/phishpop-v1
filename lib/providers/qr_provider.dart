import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/ui/generals/generals.dart';
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

    final response = await QrGalleryService.pickAndScanQrFromGallery(context);

    final navigatorContext = navigator.context;

    if (response.result == QrScanResult.success && response.qrCode != null) {
      lastResult = response.qrCode;
      processQrFromGallery(response.qrCode!, navigator);
    } else if (response.result == QrScanResult.noQrFound) {
      setState(QrScanState.idle);

      await Future.delayed(const Duration(milliseconds: 300));

      if (navigatorContext.mounted) {
        GlobalSnackBar.showError(
          navigatorContext,
          'Invalid image - No QR code detected',
        );
      }
    } else if (response.result == QrScanResult.error) {
      setState(QrScanState.idle);

      await Future.delayed(const Duration(milliseconds: 300));

      if (navigatorContext.mounted) {
        GlobalSnackBar.showError(navigatorContext, 'Error processing image');
      }
    } else {
      setState(QrScanState.idle);
    }
  }

  void processQrFromGallery(String qrResult, NavigatorState navigator) async {
    final context = navigator.context;
    final historyProvider = context.read<HistoryProvider>();
    final qrUrlProvider = context.read<QrUrlProvider>();
    final qrWifiProvider = context.read<QrWifiProvider>();

    try {
      if (isUrl(qrResult)) {
        final hasInternet = await ConnectivityHelper.hasInternetConnection();
        if (!hasInternet) {
          if (context.mounted) {
            GlobalSnackBar.showError(
              context,
              'No internet connection available',
            );
          }
          setState(QrScanState.idle);
          return;
        }

        setState(QrScanState.success);

        navigator.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoadingScreen(
                  icon: Icons.qr_code_scanner,
                  title: 'Analyzing QR Code...',
                  subtitle: 'Please wait while we analyze the QR code URL',
                  screen: QrUrlSummaryScreen(urlToAnalyze: qrResult),
                  urlToAnalyze: qrResult,
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

        qrUrlProvider.analyzeQrUrl(qrResult, historyProvider);
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
                  urlToAnalyze: qrResult,
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

        qrWifiProvider.analyzeQrWifi(qrResult, historyProvider);
      } else {
        setState(QrScanState.unsupported);
        errorMessage = 'QR code type not supported';

        if (context.mounted) {
          GlobalSnackBar.showError(context, 'QR code type not supported');
        }
      }
    } catch (e) {
      setState(QrScanState.error);
      errorMessage = e.toString();

      if (context.mounted) {
        GlobalSnackBar.showError(context, 'Error processing QR code');
      }
    }
  }

  void processQrFromCamera(
    String qrResult,
    BuildContext context,
    NavigatorState navigator,
  ) async {
    lastResult = qrResult;

    final historyProvider = context.read<HistoryProvider>();
    final qrUrlProvider = context.read<QrUrlProvider>();
    final qrWifiProvider = context.read<QrWifiProvider>();

    try {
      if (isUrl(qrResult)) {
        final hasInternet = await ConnectivityHelper.hasInternetConnection();
        if (!hasInternet) {
          if (context.mounted) {
            GlobalSnackBar.showError(
              context,
              'No internet connection available',
            );
            Navigator.of(context).pop();
          }
          setState(QrScanState.idle);
          return;
        }

        setState(QrScanState.success);

        if (context.mounted) {
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
        }

        qrUrlProvider.analyzeQrUrl(qrResult, historyProvider);
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
                  urlToAnalyze: qrResult,
                ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );

        qrWifiProvider.analyzeQrWifi(qrResult, historyProvider);
      } else {
        setState(QrScanState.unsupported);
        errorMessage = 'QR code type not supported';

        if (context.mounted) {
          Navigator.of(context).pop();
          GlobalSnackBar.showError(context, 'QR code type not supported');
        }
      }
    } catch (e) {
      setState(QrScanState.error);
      errorMessage = e.toString();

      if (context.mounted) {
        Navigator.of(context).pop();
        GlobalSnackBar.showError(context, 'Error processing QR code');
      }
    }
  }
}
