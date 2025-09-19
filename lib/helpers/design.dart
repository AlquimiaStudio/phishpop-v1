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

extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
