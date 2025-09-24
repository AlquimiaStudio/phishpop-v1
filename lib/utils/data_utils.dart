import '../models/models.dart';

List<ScamScript> getScamScripts() {
  return [
    ScamScript(
      id: 'grandparent',
      title: 'Grandparent Scam',
      redFlags: [
        'Caller claims family member is in trouble',
        'Asks for money urgently',
        'Requests wire transfer or gift cards',
        'Tells you to keep it secret',
      ],
      safeResponse:
          "I don't share personal information by phone. I will call my family member directly to verify.",
      nextSteps: [
        'Do not send money or share personal info',
        'Call family members directly using known numbers',
        'Block the caller if suspicious',
        'Report to authorities if threatened',
      ],
      officialNumbers: {'FTC Hotline': '1-877-382-4357', 'Local Police': '911'},
      reportSteps: [
        'Report scam to FTC at https://reportfraud.ftc.gov/',
        'Notify local police if threatened',
        'Inform family members about scam attempt',
      ],
    ),
    ScamScript(
      id: 'irs_scam',
      title: 'IRS/Tax Scam',
      redFlags: [
        'Claims you owe back taxes',
        'Threatens arrest or legal action',
        'Demands immediate payment',
        'Asks for gift cards or wire transfers',
      ],
      safeResponse:
          "I don't provide tax information by phone. I will contact the IRS directly using their official number.",
      nextSteps: [
        'Never give personal information over the phone',
        'Call IRS directly at their official number',
        'Block the suspicious caller',
        'File a report with authorities',
      ],
      officialNumbers: {
        'IRS': '1-800-829-1040',
        'FTC Hotline': '1-877-382-4357',
      },
      reportSteps: [
        'Report to Treasury Inspector at https://www.treasury.gov/tigta/',
        'File complaint with FTC',
        'Contact your local police',
      ],
    ),
    ScamScript(
      id: 'tech_support',
      title: 'Tech Support Scam',
      redFlags: [
        'Claims computer is infected with virus',
        'Calls from "Microsoft" or "Apple" unexpectedly',
        'Asks for remote access to computer',
        'Requests payment for "fixing" problems',
      ],
      safeResponse:
          "I don't allow remote access to my computer. I will contact tech support through official channels if needed.",
      nextSteps: [
        'Never give remote access to unknown callers',
        'Hang up immediately',
        'Run legitimate antivirus software',
        'Contact real tech support if concerned',
      ],
      officialNumbers: {
        'Microsoft Support': '1-800-642-7676',
        'Apple Support': '1-800-275-2273',
        'FTC Hotline': '1-877-382-4357',
      },
      reportSteps: [
        'Report to FTC at https://reportfraud.ftc.gov/',
        'Contact real Microsoft/Apple to report misuse',
        'Warn friends and family about the scam',
      ],
    ),
    ScamScript(
      id: 'utility_shutoff',
      title: 'Utility Shutoff Scam',
      redFlags: [
        'Claims utility service will be shut off',
        'Demands immediate payment',
        'Asks for prepaid cards or wire transfers',
        'Pressures you to act within hours',
      ],
      safeResponse:
          "I will contact my utility company directly using the number on my bill to verify any account issues.",
      nextSteps: [
        'Check your actual utility bill',
        'Call utility company using official number',
        'Never pay with gift cards or wire transfers',
        'Report the scam attempt',
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
    ),
    ScamScript(
      id: 'package_delivery',
      title: 'Package Delivery Scam',
      redFlags: [
        'Claims failed delivery attempt',
        'Asks for personal information to reschedule',
        'Suspicious tracking numbers or links',
        'Requests payment for delivery fees',
      ],
      safeResponse:
          "I will check deliveries through the official shipping company website or app.",
      nextSteps: [
        'Check tracking on official shipping websites',
        'Do not click links in suspicious messages',
        'Contact shipping company directly',
        'Block suspicious senders',
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
    ),
    ScamScript(
      id: 'romance_scam',
      title: 'Romance Scam',
      redFlags: [
        'Professes love very quickly',
        'Avoids phone calls or video chats',
        'Claims to be traveling or overseas',
        'Asks for money for emergencies',
      ],
      safeResponse:
          "I don't send money to people I haven't met in person. I will verify your identity first.",
      nextSteps: [
        'Never send money to online-only relationships',
        'Reverse image search their photos',
        'Ask specific questions about their location',
        'Trust your instincts if something feels wrong',
      ],
      officialNumbers: {
        'FTC Romance Scam': '1-877-382-4357',
        'FBI IC3': 'https://www.ic3.gov',
      },
      reportSteps: [
        'Report to FTC at https://reportfraud.ftc.gov/',
        'File complaint with FBI IC3',
        'Report to dating platform',
      ],
    ),
  ];
}

List<ScanHistoryModel> getScanHistoryData() {
  return [];
}
