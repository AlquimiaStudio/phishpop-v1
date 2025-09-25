import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';

// TrustedContact model
class TrustedContact {
  String name;
  String phone;

  TrustedContact({required this.name, required this.phone});

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone};

  factory TrustedContact.fromJson(Map<String, dynamic> json) =>
      TrustedContact(name: json['name'], phone: json['phone']);
}

final List<String> scamDetectionQuestions = [
  '1. Are you being pressured to act immediately?',
  '2. Is money or gift card requested?',
  '3. Are you asked to keep it secret?',
  '4. Is the caller claiming to be a government official?',
  '5. Is the caller asking for personal info?',
  '6. Have you verified the caller\'s identity?',
  '7. Did they contact you unexpectedly?',
];

String getScamDetectionResult(Map<int, bool?> answers) {
  int yesCount = answers.values.where((a) => a == true).length;
  if (yesCount >= 5) {
    return "Likely Scam.\nDo not share info or money. Block and report.";
  }
  if (yesCount >= 3) {
    return "Possibly Suspicious.\nVerify through official channels before acting.";
  }
  return "Likely Safe.\nProceed with caution.";
}

Color getScamDetectionResultColor(Map<int, bool?> answers) {
  int yesCount = answers.values.where((a) => a == true).length;
  if (yesCount >= 5) return AppColors.dangerColor;
  if (yesCount >= 3) return AppColors.warningColor;
  return AppColors.successColor;
}

IconData getScamDetectionResultIcon(Map<int, bool?> answers) {
  int yesCount = answers.values.where((a) => a == true).length;
  if (yesCount >= 5) return Icons.dangerous;
  if (yesCount >= 3) return Icons.warning_amber;
  return Icons.check_circle;
}

// Trusted Contacts Helper Functions
const String trustedContactsStorageKey = 'trusted_contacts';

Future<List<TrustedContact>> loadTrustedContacts() async {
  final prefs = await SharedPreferences.getInstance();
  final storedContacts = prefs.getStringList(trustedContactsStorageKey) ?? [];
  final contacts = <TrustedContact>[];

  for (var jsonString in storedContacts) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      contacts.add(TrustedContact.fromJson(json));
    } catch (_) {}
  }

  return contacts;
}

Future<void> saveTrustedContacts(List<TrustedContact> contacts) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = contacts.map((c) => jsonEncode(c.toJson())).toList();
  await prefs.setStringList(trustedContactsStorageKey, jsonList);
}

Future<void> deleteTrustedContact(
  List<TrustedContact> contacts,
  int index,
) async {
  contacts.removeAt(index);
  await saveTrustedContacts(contacts);
}

Future<void> sendCallMeMessage(
  BuildContext context,
  TrustedContact contact,
) async {
  const message =
      "Please call me as soon as possible. This might be an urgent matter.";
  final uriString = 'sms:${contact.phone}?body=${Uri.encodeComponent(message)}';
  final uri = Uri.parse(uriString);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SMS is not supported on this device'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// Quick Report Helper Functions
String generateScamReport({
  required String scamType,
  required String description,
  String? phoneNumber,
}) {
  final now = DateTime.now();
  final dateStr =
      '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

  return '''SCAM REPORT - $dateStr

SCAM TYPE: $scamType

DESCRIPTION:
$description

${phoneNumber?.isNotEmpty == true ? 'PHONE NUMBER: $phoneNumber\n' : ''}
REPORTING AGENCIES:
• FTC Consumer Sentinel: consumer.ftc.gov/consumer-sentinel-network
• FBI IC3: ic3.gov
• FCC: consumercomplaints.fcc.gov

NEXT STEPS:
• Report to local authorities if financial loss occurred
• Contact your bank/credit card company if financial info was shared
• Monitor your accounts for suspicious activity
• Consider credit monitoring services

Generated with Safe Parent - Call Mom Safe''';
}

// Safe Parent History Helper Functions
List<Map<String, dynamic>> createSafeParentHistoryEntries() {
  final now = DateTime.now();

  return [
    {
      'id': 'safe_scam_detection_${now.millisecondsSinceEpoch}',
      'scanType': 'Safe Parent',
      'title': 'Scam Detection Quiz',
      'date': _formatDate(now.subtract(const Duration(hours: 2))),
      'status': 'Likely Scam',
      'score': 85.0,
      'timestamp': now.subtract(const Duration(hours: 2)).toIso8601String(),
      'details': {
        'feature': 'Decision Helper',
        'result': 'Likely Scam',
        'yesCount': 4,
        'totalQuestions': 6,
        'recommendation': 'Do not share info or money. Block and report.',
      },
      'flaggedIssues': [
        'Pressure to act immediately',
        'Money requested',
        'Asked to keep secret',
        'Claimed to be government official',
      ],
    },
    {
      'id': 'safe_family_contact_${now.millisecondsSinceEpoch - 1}',
      'scanType': 'Safe Parent',
      'title': 'Family Contact Added',
      'date': _formatDate(now.subtract(const Duration(days: 1))),
      'status': 'Safe',
      'score': 100.0,
      'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
      'details': {
        'feature': 'Family Mode',
        'action': 'Added trusted contact',
        'contactName': 'Mom',
        'contactCount': 2,
      },
      'flaggedIssues': null,
    },
    {
      'id': 'safe_scam_report_${now.millisecondsSinceEpoch - 2}',
      'scanType': 'Safe Parent',
      'title': 'Scam Report Generated',
      'date': _formatDate(now.subtract(const Duration(days: 3))),
      'status': 'Reported',
      'score': 90.0,
      'timestamp': now.subtract(const Duration(days: 3)).toIso8601String(),
      'details': {
        'feature': 'Quick Report',
        'scamType': 'Phone Call Scam',
        'reportGenerated': true,
        'copiedToClipboard': true,
      },
      'flaggedIssues': [
        'Suspicious phone call',
        'Requested personal information',
      ],
    },
  ];
}

String _formatDate(DateTime date) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
