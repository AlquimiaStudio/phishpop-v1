import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';


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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
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

String generateScamReport({
  required String scamType,
  required String description,
  String? phoneNumber,
}) {
  final now = DateTime.now();
  final dateStr =
      '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

  final scamData = getScamReportData(scamType);

  String reportingAgencies = 'OFFICIAL REPORTING WEBSITES:\n';
  scamData['reportingWebsites'].forEach((name, url) {
    reportingAgencies += '• $name: $url\n';
  });

  String officialNumbers = '';
  if (scamData['officialNumbers'].isNotEmpty) {
    officialNumbers = '\nOFFICIAL PHONE NUMBERS:\n';
    scamData['officialNumbers'].forEach((name, number) {
      officialNumbers += '• $name: $number\n';
    });
  }

  String nextSteps = '\nRECOMMENDED ACTIONS:\n';
  for (String step in scamData['nextSteps']) {
    nextSteps += '• $step\n';
  }

  return '''🚨 SCAM INCIDENT REPORT - $dateStr

═══════════════════════════════════════════════

INCIDENT TYPE: $scamType

DETAILED DESCRIPTION:
$description

${phoneNumber?.isNotEmpty == true ? 'SCAMMER CONTACT INFO:\n• Phone Number: $phoneNumber\n\n' : ''}$reportingAgencies$officialNumbers$nextSteps
═══════════════════════════════════════════════

⚠️  IMPORTANT REMINDERS:
• Never share personal information with unverified contacts
• Do not send money via gift cards or wire transfers
• When in doubt, hang up and verify independently
• Keep records of all suspicious communications

📱 Report generated by Safe Parent - Call Mom Safe
   Protecting families from scams since 2024''';
}

Map<String, dynamic> getScamReportData(String scamType) {
  // Map dropdown types to ScamScript data
  switch (scamType.toLowerCase()) {
    case 'phone call scam':
      return {
        'reportingWebsites': {
          'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
          'FBI IC3': 'https://www.ic3.gov/',
          'AARP Fraud Watch': 'https://www.aarp.org/money/scams-fraud/',
        },
        'officialNumbers': {
          'FTC Hotline': '1-877-382-4357',
          'Local Police': '911',
        },
        'nextSteps': [
          'Hang up and verify caller identity through official channels',
          'Do not provide personal information or money',
          'Block the suspicious phone number',
          'Report to authorities if financial loss occurred',
          'Inform family members about the scam attempt',
        ],
      };

    case 'text message scam':
      return {
        'reportingWebsites': {
          'USPS Postal Inspection Service': 'https://www.uspis.gov/report',
          'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
          'Anti-Phishing Working Group': 'https://apwg.org/reportphishing/',
        },
        'officialNumbers': {
          'FTC Hotline': '1-877-382-4357',
          'USPS': '1-800-275-8777',
        },
        'nextSteps': [
          'Do not click any links in suspicious text messages',
          'Forward spam texts to 7726 (SPAM)',
          'Block the sender',
          'Delete the message after reporting',
          'Check accounts for unauthorized activity',
        ],
      };

    case 'email scam':
      return {
        'reportingWebsites': {
          'Anti-Phishing Working Group': 'https://apwg.org/reportphishing/',
          'FBI IC3': 'https://www.ic3.gov/',
          'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
        },
        'officialNumbers': {'FTC Hotline': '1-877-382-4357'},
        'nextSteps': [
          'Do not click links or download attachments',
          'Forward phishing emails to spam@uce.gov',
          'Mark as spam and delete',
          'Run antivirus scan if you clicked anything',
          'Change passwords if accounts may be compromised',
        ],
      };

    case 'online/website scam':
      return {
        'reportingWebsites': {
          'FBI IC3': 'https://www.ic3.gov/',
          'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
          'Better Business Bureau': 'https://www.bbb.org/scamtracker/',
        },
        'officialNumbers': {'FTC Hotline': '1-877-382-4357'},
        'nextSteps': [
          'Screenshot the fraudulent website before reporting',
          'Contact your bank if financial information was shared',
          'Change passwords for all online accounts',
          'Monitor credit reports for suspicious activity',
          'Report to website hosting service',
        ],
      };

    case 'social media scam':
      return {
        'reportingWebsites': {
          'FBI IC3': 'https://www.ic3.gov/',
          'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
          'Romance Scam Baiter': 'https://www.romancescam.com/forum/',
        },
        'officialNumbers': {'FTC Hotline': '1-877-382-4357'},
        'nextSteps': [
          'Report and block the scammer on the platform',
          'Screenshot all communications before blocking',
          'Never send money to online-only relationships',
          'Reverse image search profile photos',
          'Warn friends and family about the scammer',
        ],
      };

    case 'in-person scam':
      return {
        'reportingWebsites': {
          'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
          'Better Business Bureau': 'https://www.bbb.org/scamtracker/',
          'Local Police Department': 'Contact your local police',
        },
        'officialNumbers': {
          'Local Police': '911',
          'FTC Hotline': '1-877-382-4357',
        },
        'nextSteps': [
          'Report to local police immediately',
          'Gather all documentation and receipts',
          'Contact your bank if payments were made',
          'Take photos of any materials left by scammers',
          'Warn neighbors about door-to-door scammers',
        ],
      };

    default: // 'other' or unrecognized types
      return {
        'reportingWebsites': {
          'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
          'FBI IC3': 'https://www.ic3.gov/',
          'Better Business Bureau': 'https://www.bbb.org/scamtracker/',
        },
        'officialNumbers': {
          'FTC Hotline': '1-877-382-4357',
          'Local Police': '911',
        },
        'nextSteps': [
          'Report to appropriate authorities',
          'Document all evidence and communications',
          'Monitor accounts for suspicious activity',
          'Contact financial institutions if money was involved',
          'Inform family and friends to prevent similar scams',
        ],
      };
  }
}

const List<String> scamTypes = [
  'Phone Call Scam',
  'Text Message Scam',
  'Email Scam',
  'Online/Website Scam',
  'Social Media Scam',
  'In-Person Scam',
  'Other',
];
