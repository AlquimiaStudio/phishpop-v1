import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum QrScanResult { success, noQrFound, cancelled, error }

class QrGalleryResponse {
  final QrScanResult result;
  final String? qrCode;

  QrGalleryResponse({required this.result, this.qrCode});
}

class QrGalleryService {
  static final ImagePicker picker = ImagePicker();

  static Future<QrGalleryResponse> pickAndScanQrFromGallery(
    BuildContext context,
  ) async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        return QrGalleryResponse(result: QrScanResult.cancelled);
      }

      final String? qrResult = await scanQrFromImage(image.path);

      if (qrResult == null) {
        return QrGalleryResponse(result: QrScanResult.noQrFound);
      }

      return QrGalleryResponse(result: QrScanResult.success, qrCode: qrResult);
    } catch (e) {
      return QrGalleryResponse(result: QrScanResult.error);
    }
  }

  static Future<String?> scanQrFromImage(String imagePath) async {
    try {
      final MobileScannerController controller = MobileScannerController(
        autoStart: false,
      );

      final BarcodeCapture? capture = await controller.analyzeImage(imagePath);

      await controller.dispose();

      if (capture != null && capture.barcodes.isNotEmpty) {
        for (final barcode in capture.barcodes) {
          if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
            return barcode.rawValue;
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
