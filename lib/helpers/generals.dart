import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/widgets.dart';

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

Color getRiskLevelColor(String? riskLevel, String fallbackStatus) {
  // If riskLevel is available, use it (more accurate)
  if (riskLevel != null && riskLevel.isNotEmpty) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return AppColors.successColor;
      case 'medium':
        return AppColors.warningColor;
      case 'high':
      case 'critical':
        return AppColors.dangerColor;
      default:
        return getStatusColor(fallbackStatus);
    }
  }
  // Otherwise fall back to status
  return getStatusColor(fallbackStatus);
}

String getDisplayStatus(String? riskLevel, String fallbackStatus) {
  // If riskLevel is available, use it as the display label
  if (riskLevel != null && riskLevel.isNotEmpty) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return 'safe';
      case 'medium':
        return 'warning';
      case 'high':
        return 'threat';
      case 'critical':
        return 'threat';
      default:
        return fallbackStatus;
    }
  }
  // Otherwise use the status as-is
  return fallbackStatus;
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

List<Map<String, dynamic>> getStatsExplanations() {
  return [
    {
      'title': 'Total Scans',
      'icon': Icons.analytics,
      'explanation':
          'Shows the total number of security scans you have performed across all types (URLs, text, QR codes, and WiFi networks).',
    },
    {
      'title': 'Threats Detected',
      'icon': Icons.warning,
      'explanation':
          'Displays the number and percentage of scans that identified potential security threats or suspicious content.',
    },
    {
      'title': 'Protection Level',
      'icon': Icons.shield,
      'explanation':
          'Your overall security score based on scan results. Higher scores indicate better protection and fewer security risks.',
    },
    {
      'title': 'Last Activity',
      'icon': Icons.schedule,
      'explanation':
          'Shows when you last performed a security scan and what type of scan it was.',
    },
    {
      'title': 'Confidence Score',
      'icon': Icons.verified,
      'explanation':
          'Average confidence level of our security analysis. Higher scores indicate more reliable threat detection.',
    },
    {
      'title': 'Security Classification',
      'icon': Icons.bar_chart,
      'explanation':
          'Bar chart showing the distribution of scan results: Safe (no threats), Suspicious (potential risks), and Unsafe (confirmed threats).',
    },
    {
      'title': 'Scan Types Distribution',
      'icon': Icons.pie_chart,
      'explanation':
          'Pie chart displaying the breakdown of different types of scans you have performed (URL, Text, QR Code, WiFi).',
    },
    {
      'title': 'Top Security Issues',
      'icon': Icons.list,
      'explanation':
          'Lists the most frequently detected security problems in your scans, ranked by occurrence frequency.',
    },
  ];
}

List<Map<String, dynamic>> getTextAnalysisExplanations() {
  return [
    {
      'title': 'Confidence',
      'icon': Icons.verified,
      'explanation':
          'How sure we are about our analysis (0-100%):\n• 90-100%: Very confident in the result\n• 70-89%: Fairly confident\n• Below 70%: Less certain, be extra careful',
    },
    {
      'title': 'Text Analysis',
      'icon': Icons.analytics,
      'explanation':
          'Technical score from analyzing the message content:\n• Higher scores indicate more suspicious patterns\n• Combines multiple detection methods\n• Helps determine overall safety',
    },
    {
      'title': 'Risk Level',
      'icon': Icons.warning_amber,
      'explanation':
          'How dangerous this message might be:\n• Low: Very safe to interact with\n• Medium: Be cautious, some suspicious signs\n• High: Avoid clicking links or sharing info',
    },
    {
      'title': 'Scan Time',
      'icon': Icons.schedule,
      'explanation':
          'When we analyzed this message:\n• Shows the date and time of analysis\n• Recent scans are more reliable\n• Helps track when threats were detected',
    },
    {
      'title': 'Processing',
      'icon': Icons.timer,
      'explanation':
          'How long the analysis took:\n• Measured in milliseconds (ms)\n• Complex messages take longer\n• Typical range: 100-2000ms',
    },
    {
      'title': 'Scan Type',
      'icon': Icons.category,
      'explanation':
          'What kind of content was analyzed:\n• Text: Message content analysis\n• URL: Web link safety check\n• Email: Full email analysis',
    },
    {
      'title': 'Classification',
      'icon': Icons.label,
      'explanation':
          'What type of message this is:\n• Legitimate: Safe, normal message\n• Spam: Unwanted promotional content\n• Phishing: Trying to steal passwords/info\n• Scam: Fraudulent, trying to trick you',
    },
    {
      'title': 'Flagged Issues',
      'icon': Icons.flag,
      'explanation':
          'Specific problems found in the message:\n• Suspicious links or attachments\n• Urgent language trying to pressure you\n• Requests for personal information\n• Other warning signs',
    },
  ];
}

List<Map<String, dynamic>> getQrUrlAnalysisExplanations() {
  return [
    {
      'title': 'Confidence',
      'icon': Icons.verified,
      'explanation':
          'How sure we are about our analysis (0-100%):\n• 90-100%: Very confident in the result\n• 70-89%: Fairly confident\n• Below 70%: Less certain, be extra careful',
    },
    {
      'title': 'QR URL',
      'icon': Icons.qr_code,
      'explanation':
          'The original URL found in the QR code:\n• This is what the QR code contains\n• May be a shortened URL (bit.ly, tinyurl, etc.)\n• Could redirect to a different destination',
    },
    {
      'title': 'Destination URL',
      'icon': Icons.open_in_new,
      'explanation':
          'Where the QR URL actually leads:\n• The final destination after all redirects\n• This is what you\'ll see if you click the link\n• May be different from the QR URL if redirected',
    },
    {
      'title': 'URL Analysis',
      'icon': Icons.link,
      'explanation':
          'Technical score from analyzing the website URL:\n• Checks domain reputation and history\n• Analyzes URL structure for suspicious patterns\n• Combines multiple security databases',
    },
    {
      'title': 'Risk Level',
      'icon': Icons.warning_amber,
      'explanation':
          'How dangerous this website might be:\n• Low: Very safe to visit\n• Medium: Be cautious, some suspicious signs\n• High: Avoid visiting, likely malicious',
    },
    {
      'title': 'Scan Time',
      'icon': Icons.schedule,
      'explanation':
          'When we analyzed this QR URL:\n• Shows the date and time of analysis\n• Recent scans are more reliable\n• Helps track when threats were detected',
    },
    {
      'title': 'Processing',
      'icon': Icons.timer,
      'explanation':
          'How long the analysis took:\n• Measured in milliseconds (ms)\n• Complex URLs take longer to verify\n• Typical range: 200-3000ms',
    },
    {
      'title': 'Scan Type',
      'icon': Icons.category,
      'explanation':
          'What kind of content was analyzed:\n• QR: QR code URL analysis\n• Real-time: Live threat detection\n• Redirect analysis included',
    },
    {
      'title': 'Classification',
      'icon': Icons.label,
      'explanation':
          'What type of website this is:\n• Legitimate: Safe, trusted website\n• Suspicious: Potentially harmful content\n• Phishing: Trying to steal passwords/info\n• Malware: Contains malicious software',
    },
    {
      'title': 'Flagged Issues',
      'icon': Icons.flag,
      'explanation':
          'Specific problems found with the QR URL:\n• Suspicious domain or subdomain\n• URL shortener detected\n• Redirects to suspicious domains\n• SSL certificate issues',
    },
  ];
}

List<Map<String, dynamic>> getUrlAnalysisExplanations() {
  return [
    {
      'title': 'Confidence',
      'icon': Icons.verified,
      'explanation':
          'How sure we are about our analysis (0-100%):\n• 90-100%: Very confident in the result\n• 70-89%: Fairly confident\n• Below 70%: Less certain, be extra careful',
    },
    {
      'title': 'URL Analysis',
      'icon': Icons.link,
      'explanation':
          'Technical score from analyzing the website URL:\n• Checks domain reputation and history\n• Analyzes URL structure for suspicious patterns\n• Combines multiple security databases',
    },
    {
      'title': 'Risk Level',
      'icon': Icons.warning_amber,
      'explanation':
          'How dangerous this website might be:\n• Low: Very safe to visit\n• Medium: Be cautious, some suspicious signs\n• High: Avoid visiting, likely malicious',
    },
    {
      'title': 'Scan Time',
      'icon': Icons.schedule,
      'explanation':
          'When we analyzed this URL:\n• Shows the date and time of analysis\n• Recent scans are more reliable\n• Helps track when threats were detected',
    },
    {
      'title': 'Processing',
      'icon': Icons.timer,
      'explanation':
          'How long the analysis took:\n• Measured in milliseconds (ms)\n• Complex URLs take longer to verify\n• Typical range: 200-3000ms',
    },
    {
      'title': 'Scan Type',
      'icon': Icons.category,
      'explanation':
          'What kind of content was analyzed:\n• URL: Web link safety check\n• Domain: Website reputation analysis\n• Real-time: Live threat detection',
    },
    {
      'title': 'Classification',
      'icon': Icons.label,
      'explanation':
          'What type of website this is:\n• Legitimate: Safe, trusted website\n• Suspicious: Potentially harmful content\n• Phishing: Trying to steal passwords/info\n• Malware: Contains malicious software',
    },
    {
      'title': 'Flagged Issues',
      'icon': Icons.flag,
      'explanation':
          'Specific problems found with the URL:\n• Suspicious domain or subdomain\n• Known malicious hosting provider\n• Recently registered domain\n• SSL certificate issues',
    },
  ];
}

List<Map<String, dynamic>> getSafeParentModulesExplanations() {
  return [
    {
      'title': 'Scam Library',
      'icon': Icons.library_books,
      'explanation':
          'Access a comprehensive database of known scam types and patterns:\n• Learn to identify common phone scams\n• View real examples of fraudulent messages\n• Understand scammer tactics and red flags\n• Stay updated on emerging threats',
    },
    {
      'title': 'Decision Helper',
      'icon': Icons.help_outline,
      'explanation':
          'Get instant guidance when you\'re unsure about a communication:\n• Step-by-step questions to assess threats\n• Quick yes/no decisions for suspicious messages\n• Expert recommendations based on your answers\n• Peace of mind for uncertain situations',
    },
    {
      'title': 'Family Mode',
      'icon': Icons.family_restroom,
      'explanation':
          'Protect your family members from scams and fraud:\n• Set up protection for elderly relatives\n• Monitor and block suspicious communications\n• Share safety tips and alerts with family\n• Remote assistance for vulnerable family members',
    },
    {
      'title': 'Quick Report',
      'icon': Icons.report_problem,
      'explanation':
          'Easily report suspicious communications to authorities:\n• One-tap reporting of scam attempts\n• Automatically formatted reports for law enforcement\n• Contribute to community safety databases\n• Help protect others from similar threats',
    },
  ];
}

void showExplanationModal(
  BuildContext context,
  List<Map<String, dynamic>> Function() getExplanations, {
  String? customTitle,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ExplanationModal(
      getExplanations: getExplanations,
      customTitle: customTitle,
    ),
  );
}

Map<String, String> getPricingInfo(bool isAnnual) {
  if (isAnnual) {
    return {
      'price': '79',
      'cents': '.99',
      'period': 'per year',
      'savings': 'Save \$39.89 (33% off)',
    };
  } else {
    return {'price': '9', 'cents': '.99', 'period': 'per month', 'savings': ''};
  }
}

List<Map<String, dynamic>> getPremiumFeatures() {
  return [
    {
      'icon': Icons.all_inclusive,
      'title': 'Unlimited Scans*',
      'description':
          'No limits on SMS, email, QR WiFi, QR URL and URL analysis',
    },
    {
      'icon': Icons.psychology,
      'title': 'Advanced AI Detection',
      'description': 'Enhanced threat detection with latest AI models',
    },
    {
      'icon': Icons.headset_mic,
      'title': 'Priority Support',
      'description': '24/7 premium customer support',
    },
    {
      'icon': Icons.dashboard,
      'title': 'Full Metrics Dashboard',
      'description': 'Complete access to all charts and analytics data',
    },
  ];
}

List<Map<String, dynamic>> getFamilyModeFeatures() {
  return [
    {'icon': Icons.report, 'title': 'Quick Government Reporting'},
    {'icon': Icons.library_books, 'title': 'Official Scam Library'},
    {'icon': Icons.contacts, 'title': 'Emergency Family Contacts'},
    {'icon': Icons.sos, 'title': 'One-tap SOS Messages'},
  ];
}

List<Map<String, dynamic>> getTrustBadges() {
  return [
    {'icon': Icons.security, 'text': '256-bit\nEncryption'},
    {'icon': Icons.privacy_tip, 'text': 'Privacy\nFirst'},
  ];
}
