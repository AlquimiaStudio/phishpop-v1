enum SharedContentType { url, text, unknown }

class SharedContentDetectorService {
  static bool isUrl(String text) {
    if (text.isEmpty) return false;

    final cleanText = text.trim();

    final urlPattern = RegExp(
      r'^(https?:\/\/)?'
      r'(www\.)?'
      r'[a-zA-Z0-9\-]+'
      r'(\.[a-zA-Z]{2,})+'
      r'(\/[^\s]*)?$',
      caseSensitive: false,
    );

    if (urlPattern.hasMatch(cleanText)) {
      return true;
    }

    if (cleanText.toLowerCase().startsWith('http://') ||
        cleanText.toLowerCase().startsWith('https://') ||
        cleanText.toLowerCase().startsWith('www.')) {
      return true;
    }

    return false;
  }

  static String normalizeUrl(String url) {
    String cleanUrl = url.trim();

    if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://$cleanUrl';
    }

    return cleanUrl;
  }

  static SharedContentType detectContentType(String content) {
    if (content.isEmpty) {
      return SharedContentType.unknown;
    }

    if (isUrl(content)) {
      return SharedContentType.url;
    }

    return SharedContentType.text;
  }
}
