import '../models/models.dart';

List<ScamScript> getScamScripts() {
  return [
    ScamScript(
      id: 'grandparent',
      title: 'Grandparent Scam',
      redFlags: [
        'Urgent call claiming family member is in jail or hospital',
        'Insists on secrecy - "don\'t tell mom and dad"',
        'Demands money via wire transfer or gift cards only',
        'Voice sounds different but claims to have a cold',
        'Won\'t let you speak to anyone else or verify details',
      ],
      safeResponse:
          "I don't share personal information by phone. I will call my family member directly to verify.",
      nextSteps: [
        'Hang up and call your family member directly',
        'Use known phone numbers, not ones the caller provides',
        'Ask questions only the real person would know',
      ],
      officialNumbers: {'FTC Hotline': '1-877-382-4357', 'Local Police': '911'},
      reportSteps: [
        'Report scam to FTC',
        'Notify local police if threatened',
        'Inform family members about scam attempt',
      ],
      reportingWebsites: {
        'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
        'AARP Fraud Watch': 'https://www.aarp.org/money/scams-fraud/',
        'Elder Justice Initiative': 'https://www.justice.gov/elderjustice',
      },
    ),
    ScamScript(
      id: 'irs_scam',
      title: 'IRS/Tax Scam',
      redFlags: [
        'Aggressive threats of immediate arrest',
        'Demands payment in specific forms (gift cards, Bitcoin)',
        'Claims you owe back taxes with no prior notice',
      ],
      safeResponse:
          "I don't provide tax information by phone. I will contact the IRS directly using their official number.",
      nextSteps: [
        'Know that the IRS contacts taxpayers by mail first, never by phone',
        'Call the IRS directly at 1-800-829-1040 to verify',
        'Never pay taxes with gift cards or cryptocurrency',
        'Hang up immediately and block the number',
        'Document the call details for reporting',
      ],
      officialNumbers: {
        'IRS': '1-800-829-1040',
        'FTC Hotline': '1-877-382-4357',
      },
      reportSteps: [
        'Report to Treasury Inspector',
        'File complaint with FTC',
        'Contact your local police',
      ],
      reportingWebsites: {
        'TIGTA (Treasury Inspector General)': 'https://www.tigta.gov/',
        'IRS Tax Scam Reporting':
            'https://www.irs.gov/privacy-disclosure/report-phishing',
        'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
      },
    ),
    ScamScript(
      id: 'tech_support',
      title: 'Tech Support Scam',
      redFlags: [
        'Unsolicited call claiming your computer has viruses',
        'Claims to be from Microsoft, Apple, or your internet provider',
        'Asks to download remote access software',
        'Shows fake error messages or pop-ups',
        'Requests credit card info for "security software"',
        'Creates urgency claiming your data is at risk',
      ],
      safeResponse:
          "I don't allow remote access to my computer. I will contact tech support through official channels if needed.",
      nextSteps: [
        'Hang up immediately - legitimate companies don\'t call unsolicited',
        'Run your own antivirus scan if concerned',
      ],
      officialNumbers: {
        'Microsoft Support': '1-800-642-7676',
        'Apple Support': '1-800-275-2273',
        'FTC Hotline': '1-877-382-4357',
      },
      reportSteps: [
        'Report to FTC',
        'Contact real Microsoft/Apple to report misuse',
        'Warn friends and family about the scam',
      ],
      reportingWebsites: {
        'Microsoft Security Response Center':
            'https://msrc.microsoft.com/report',
        'Apple Product Security': 'https://support.apple.com/102672',
        'FBI IC3': 'https://www.ic3.gov/',
        'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
      },
    ),
    ScamScript(
      id: 'utility_shutoff',
      title: 'Utility Shutoff Scam',
      redFlags: [
        'Immediate disconnection threat within hours',
        'Payment only accepted via prepaid cards',
        'No prior notice or bills received',
        'Caller ID shows utility company but seems suspicious',
      ],
      safeResponse:
          "I will contact my utility company directly using the number on my bill to verify any account issues.",
      nextSteps: [
        'Check your most recent utility bill for actual balance',
        'Call your utility using the official number on your bill',
        'Utilities typically provide multiple notices before disconnection',
        'Legitimate utilities accept various payment methods, not just gift cards',
        'Ask for account details that scammers wouldn\'t know',
        'Request written notice of any disconnection',
      ],
      officialNumbers: {
        'FTC Hotline': '1-877-382-4357',
        'Local Utility Company': 'Check your bill',
      },
      reportSteps: [
        'Contact your utility company to report scam',
        'File report with FTC',
        'Warn neighbors about the scam',
      ],
      reportingWebsites: {
        'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
        'Better Business Bureau': 'https://www.bbb.org/scamtracker/',
        'Your State Public Utilities Commission':
            'https://www.naruc.org/about-naruc/consumer-resources/',
      },
    ),
    ScamScript(
      id: 'package_delivery',
      title: 'Package Delivery Scam',
      redFlags: [
        'Text or email about failed delivery for package you didn\'t order',
        'Suspicious links asking for personal information',
        'Requests additional delivery fees',
      ],
      safeResponse:
          "I will check deliveries through the official shipping company website or app.",
      nextSteps: [
        'Go directly to UPS.com, FedEx.com, or USPS.com to track',
        'Never click links in suspicious delivery texts',
        'Contact the shipping company directly if concerned',
      ],
      officialNumbers: {
        'UPS': '1-800-742-5877',
        'FedEx': '1-800-463-3339',
        'USPS': '1-800-275-8777',
      },
      reportSteps: [
        'Forward suspicious emails to spam@uce.gov',
        'Report to shipping company security',
        'File complaint with FTC',
      ],
      reportingWebsites: {
        'USPS Postal Inspection Service': 'https://www.uspis.gov/report',
        'UPS Security': 'https://www.ups.com/us/en/help-center/contact.page',
        'FedEx Security':
            'https://www.fedex.com/en-us/trust-center/report-fraud.html',
        'Anti-Phishing Working Group': 'https://apwg.org/reportphishing/',
      },
    ),
    ScamScript(
      id: 'romance_scam',
      title: 'Romance Scam',
      redFlags: [
        'Professes love unusually quickly in online relationship',
        'Always has excuses to avoid meeting in person',
        'Claims to be traveling, in military, or overseas',
        'Photos look too professional or model-like',
        'Stories don\'t add up or change over time',
        'Asks for money for emergencies, travel, or medical bills',
        'Wants gift cards, wire transfers, or cryptocurrency',
      ],
      safeResponse:
          "I don't send money to people I haven't met in person. I will verify your identity first.",
      nextSteps: [
        'Never send money, gifts, or personal information',
        'Do a reverse image search of their photos',
        'Ask for a video call - scammers often refuse',
        'Trust your instincts if something feels wrong',
        'Talk to friends or family about the relationship',
      ],
      officialNumbers: {
        'FTC Romance Scam': '1-877-382-4357',
        'FBI IC3': 'https://www.ic3.gov',
      },
      reportSteps: [
        'Report to FTC',
        'File complaint with FBI IC3',
        'Report to dating platform',
      ],
      reportingWebsites: {
        'FBI IC3 (Internet Crime)': 'https://www.ic3.gov/',
        'FTC Consumer Sentinel': 'https://reportfraud.ftc.gov/',
        'Romance Scam Baiter': 'https://www.romancescam.com/forum/',
        'Scammer.info Community': 'https://scammer.info/',
      },
    ),
  ];
}
