import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrGalleryService {
  static final ImagePicker picker = ImagePicker();

  static Future<String?> pickAndScanQrFromGallery(BuildContext context) async {
    try {
      // Pick image from gallery
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        if (context.mounted) {
          showSnackBar(context, 'No image selected');
        }
        return null;
      }

      // Scan QR code from the selected image
      final String? qrResult = await scanQrFromImage(image.path);

      if (qrResult == null) {
        if (context.mounted) {
          showSnackBar(context, 'No QR code found in the selected image');
        }
        return null;
      }

      return qrResult;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error processing image: ${e.toString()}');
      }
      return null;
    }
  }

  static Future<String?> scanQrFromImage(String imagePath) async {
    try {
      final MobileScannerController controller = MobileScannerController(
        autoStart: false, // Evitar inicio automático
      );

      // Analyze the image for QR codes sin inicializar
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

  static void showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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
}
