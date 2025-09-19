import 'package:flutter/material.dart';

import '../theme/theme.dart';

IconData getIcon(String scanType) {
  switch (scanType) {
    case 'text':
      return Icons.text_fields;
    case 'url':
      return Icons.link;
    case 'wifi':
      return Icons.wifi;
    case 'webpage':
      return Icons.web;
    default:
      return Icons.text_fields;
  }
}

Color getIconColor(String scanType) {
  switch (scanType) {
    case 'text':
      return Colors.orange;
    case 'url':
      return Colors.red;
    case 'wifi':
      return Colors.blue;
    case 'webpage':
      return Colors.purple;
    default:
      return AppColors.primaryColor;
  }
}

Color getStatusColor(String scanStatus) {
  switch (scanStatus) {
    case 'safe':
      return AppColors.successColor;
    case 'threat':
      return AppColors.dangerColor;
    case 'warning':
      return AppColors.warningColor;

    default:
      return AppColors.warningColor;
  }
}

String formatTimestamp(String timestamp) {
  try {
    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays <= 5) {
      return '${difference.inDays} days ago';
    } else {
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year.toString().substring(2)}';
    }
  } catch (e) {
    return 'Unknown';
  }
}

String getUrlConfidenceDescription(String result) {
  switch (result.toLowerCase()) {
    case 'safe':
      return 'URL appears completely safe';
    case 'unsafe':
      return 'URL contains security threats';
    case 'warning':
      return 'URL shows suspicious indicators';
    default:
      return 'Unknown status';
  }
}

String getTextConfidenceDescription(String result) {
  switch (result.toLowerCase()) {
    case 'safe':
      return 'Text appears completely safe';
    case 'unsafe':
      return 'Text contains phishing indicators';
    case 'warning':
      return 'Text shows suspicious patterns';
    default:
      return 'Unknown status';
  }
}

String formatIssueText(String issue) {
  return issue
      .replaceAll('_', ' ')
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (match) => '${match[1]} ${match[2]}',
      )
      .split(' ')
      .map(
        (word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '',
      )
      .join(' ');
}

String? validateAndFormatUrl(String input) {
  String url = input.trim();

  if (url.isEmpty) {
    throw Exception('Please enter a URL');
  }

  String domainToCheck = url;
  if (url.startsWith('http://')) {
    domainToCheck = url.substring(7);
  } else if (url.startsWith('https://')) {
    domainToCheck = url.substring(8);
  }

  if (domainToCheck.isEmpty) {
    throw Exception('Please enter a valid URL');
  }

  String domainOnly = domainToCheck.split('/')[0];

  if (domainOnly == 'localhost') {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  List<String> parts = domainOnly.split('.');

  if (parts.length < 2) {
    throw Exception('Please enter a valid URL with domain and extension');
  }

  if (parts.any((part) => part.isEmpty)) {
    throw Exception('Please enter a valid URL');
  }

  String tld = parts.last;
  if (tld.length < 2 || !RegExp(r'^[a-zA-Z]{2,}$').hasMatch(tld)) {
    throw Exception(
      'Please enter a valid URL with a proper extension (e.g., .com, .org)',
    );
  }

  String domain = parts[parts.length - 2];
  if (domain.isEmpty || !RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(domain)) {
    throw Exception('Please enter a valid domain name');
  }

  if (!RegExp(
    r'^[a-zA-Z0-9]([a-zA-Z0-9\-\.]*[a-zA-Z0-9])?(/.*)?$',
  ).hasMatch(domainToCheck)) {
    throw Exception('Please enter a valid URL');
  }

  if (domainToCheck.endsWith('.') || domainToCheck.endsWith('@')) {
    throw Exception('Please enter a valid URL');
  }

  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'https://$url';
  }

  Uri? uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
    throw Exception('Please enter a valid URL');
  }

  if (uri.host.isEmpty || uri.host.length < 2) {
    throw Exception('Please enter a valid URL');
  }

  return url;
}

String? validateAndFormatText(String input) {
  String text = input.trim();

  if (text.isEmpty) {
    throw Exception('Please enter some text to analyze');
  }

  if (text.length < 10) {
    throw Exception('Text is too short. Please enter at least 10 characters');
  }

  if (text.length > 10000) {
    throw Exception(
      'Text is too long. Please enter less than 10,000 characters',
    );
  }

  String cleanText = text.replaceAll(RegExp(r'[\s\n\r\t]+'), ' ');
  if (cleanText.replaceAll(RegExp(r'[^\w\s]'), '').trim().isEmpty) {
    throw Exception('Please enter meaningful text with words');
  }

  List<String> words = cleanText
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty && RegExp(r'[a-zA-Z]').hasMatch(word))
      .toList();

  if (words.length < 2) {
    throw Exception('Text should contain at least 2 words');
  }

  text = text
      .replaceAll(RegExp(r'\r\n|\r'), '\n')
      .replaceAll(RegExp(r'\n+'), '\n')
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      .trim();

  return text;
}

String getTextResultTitle(String classification) {
  switch (classification.toLowerCase()) {
    case 'legitimate':
      return 'Text is Safe';
    case 'spam':
      return 'Spam Detected';
    case 'phishing':
      return 'Phishing Detected';
    case 'scam':
      return 'Scam Detected';
    default:
      return 'Threat Detected';
  }
}

String getTextResultSubtitle(String classification) {
  switch (classification.toLowerCase()) {
    case 'legitimate':
      return 'No threats detected in this text';
    case 'spam':
      return 'Unwanted promotional or bulk content detected';
    case 'phishing':
      return 'Potential credential theft attempt detected';
    case 'scam':
      return 'Fraudulent content attempting to deceive users';
    default:
      return 'Potentially malicious content found';
  }
}
