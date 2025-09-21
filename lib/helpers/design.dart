import 'package:flutter/material.dart';

import '../theme/theme.dart';

BoxDecoration getBoxShadow(BuildContext context) => BoxDecoration(
  color: Theme.of(context).cardColor,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: Colors.grey[300]!),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);

IconData getIssueIcon(String issue) {
  final lowerIssue = issue.toLowerCase();

  if (lowerIssue.contains('phish') || lowerIssue.contains('scam')) {
    return Icons.phishing;
  } else if (lowerIssue.contains('malware') || lowerIssue.contains('virus')) {
    return Icons.bug_report;
  } else if (lowerIssue.contains('redirect') ||
      lowerIssue.contains('shortened')) {
    return Icons.link_off;
  } else if (lowerIssue.contains('suspicious') ||
      lowerIssue.contains('threat')) {
    return Icons.warning;
  } else if (lowerIssue.contains('blocked') ||
      lowerIssue.contains('blacklist')) {
    return Icons.block;
  } else {
    return Icons.error_outline;
  }
}

Color getCardColor(String result) {
  switch (result) {
    case 'safe':
      return AppColors.successColor;
    case 'unsafe':
      return AppColors.dangerColor;
    default:
      return AppColors.warningColor;
  }
}

IconData getCardIcon(String result) {
  switch (result) {
    case 'safe':
      return Icons.verified_user;
    case 'unsafe':
      return Icons.dangerous;
    default:
      return Icons.warning;
  }
}

String getUrlTitle(String result) {
  switch (result.toLowerCase()) {
    case 'safe':
      return 'URL is Safe';
    case 'unsafe':
      return 'URL is Unsafe';
    case 'warning':
      return 'URL Warning';
    default:
      return 'Unknown Status';
  }
}

String getUrlDescription(String result) {
  switch (result.toLowerCase()) {
    case 'safe':
      return 'No security threats detected';
    case 'unsafe':
      return 'Security threats detected';
    case 'warning':
      return 'Potential security concerns detected';
    default:
      return 'Status unknown';
  }
}

IconData getWifiIcon(String result) {
  switch (result) {
    case 'safe':
      return Icons.wifi_lock;
    case 'unsafe':
      return Icons.wifi_off;
    default:
      return Icons.wifi_2_bar;
  }
}

String getWifiTitle(String result) {
  switch (result.toLowerCase()) {
    case 'safe':
      return 'WiFi is Safe';
    case 'unsafe':
      return 'WiFi is Unsafe';
    case 'suspicious':
      return 'WiFi Warning';
    default:
      return 'Unknown Status';
  }
}

String getWifiDescription(String result) {
  switch (result.toLowerCase()) {
    case 'safe':
      return 'Network is secure and safe to connect';
    case 'unsafe':
      return 'Network has security vulnerabilities';
    case 'suspicious':
      return 'Network may have security concerns';
    default:
      return 'Security status unknown';
  }
}

String getWifiConfidenceDescription(double confidence) {
  if (confidence >= 0.9) {
    return 'Very High Confidence';
  } else if (confidence >= 0.8) {
    return 'High Confidence';
  } else if (confidence >= 0.7) {
    return 'Medium Confidence';
  } else if (confidence >= 0.6) {
    return 'Low Confidence';
  } else {
    return 'Very Low Confidence';
  }
}

List<Map<String, dynamic>> getQrWifiAnalysisExplanations() {
  return [
    {
      'title': 'Security Score',
      'icon': Icons.shield,
      'explanation':
          'Measures the overall security of the WiFi network:\n• Encryption type (WPA3 > WPA2 > WPA > WEP > Open)\n• Password strength and complexity\n• Network configuration vulnerabilities',
    },
    {
      'title': 'Risk Level',
      'icon': Icons.warning_amber,
      'explanation':
          'Indicates the potential risk of connecting to this network:\n• Low: Secure networks with strong encryption\n• Medium: Some security concerns detected\n• High: Significant vulnerabilities present\n• Critical: Dangerous networks to avoid',
    },
    {
      'title': 'Classification',
      'icon': Icons.category,
      'explanation':
          'Categorizes the network based on security analysis:\n• Safe: Secure and trustworthy networks\n• Suspicious: Networks with questionable security\n• Insecure: Networks with known vulnerabilities\n• Dangerous: Networks that pose security risks',
    },
    {
      'title': 'Signal Strength',
      'icon': Icons.wifi,
      'explanation':
          'Shows the WiFi signal quality and strength:\n• Excellent: -30dBm or better\n• Good: -50dBm to -30dBm\n• Fair: -60dBm to -50dBm\n• Poor: Below -60dBm',
    },
  ];
}

extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
