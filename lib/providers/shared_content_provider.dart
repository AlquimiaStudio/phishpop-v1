import 'package:flutter/material.dart';
import '../services/shared_content_detector_service.dart';

class SharedContentProvider extends ChangeNotifier {
  String? sharedContent;
  SharedContentType contentType = SharedContentType.unknown;

  void setSharedContent(String? content) {
    if (content == null || content.isEmpty) {
      clearSharedContent();
      return;
    }

    sharedContent = content;
    contentType = SharedContentDetectorService.detectContentType(content);
    notifyListeners();
  }

  void clearSharedContent() {
    sharedContent = null;
    contentType = SharedContentType.unknown;
    notifyListeners();
  }

  String? consumeSharedContent() {
    final content = sharedContent;
    clearSharedContent();
    return content;
  }
}
