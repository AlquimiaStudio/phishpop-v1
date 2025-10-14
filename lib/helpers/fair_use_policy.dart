import 'package:flutter/material.dart';
import '../widgets/privacy_security/security.dart';

Widget buildFairUsePolicyIntro() {
  return PolicySection(
    title: 'Fair Use Policy',
    icon: Icons.policy,
    children: [
      PolicyItem(
        text:
            'Our Fair Use Policy ensures optimal service quality for all users while maintaining sustainable infrastructure costs.',
      ),
      PolicyItem(
        text:
            'Premium subscribers enjoy generous usage limits designed for typical security-conscious usage patterns.',
      ),
      PolicyItem(
        text:
            'These limits are rarely reached by regular users and are designed to prevent abuse, not restrict legitimate use.',
      ),
    ],
  );
}

Widget buildUsageLimitsSection() {
  return PolicySection(
    title: 'Premium Usage Limits',
    icon: Icons.analytics,
    children: [
      PolicyItem(title: 'AI Text Analysis:', text: '100 scans per month'),
      PolicyItem(title: 'Link & Email Analysis:', text: '200 scans per month'),
      PolicyItem(title: 'QR Link Analysis:', text: '100 scans per month'),
      PolicyItem(
        title: 'QR WiFi Analysis:',
        text: 'Unlimited (local processing, no API costs)',
      ),
      PolicyItem(
        text:
            'Total: Approximately 400 AI-powered scans per month, which is generous for typical usage.',
      ),
    ],
  );
}

Widget buildFreeUserLimitsSection() {
  return PolicySection(
    title: 'Free User Access',
    icon: Icons.account_circle_outlined,
    children: [
      PolicyItem(
        text:
            'Free users have full access to Family Mode features including quick reporting, scam library, emergency contacts, and SOS alerts.',
      ),
      PolicyItem(
        text:
            'QR WiFi analysis is available for all users as it processes locally on your device.',
      ),
      PolicyItem(
        text:
            'Upgrade to Premium for unlimited AI-powered threat detection across text, links, emails, and QR URLs.',
      ),
    ],
  );
}

Widget buildWhyLimitsSection() {
  return PolicySection(
    title: 'Why We Have Limits',
    icon: Icons.help_outline,
    children: [
      PolicyItem(
        title: 'Infrastructure Costs:',
        text:
            'AI-powered analysis uses OpenAI and backend services that incur real costs per scan.',
      ),
      PolicyItem(
        title: 'Service Quality:',
        text:
            'Limits ensure fast response times and reliable service for all users.',
      ),
      PolicyItem(
        title: 'Abuse Prevention:',
        text: 'Usage caps prevent automated bulk scanning and service abuse.',
      ),
      PolicyItem(
        title: 'Sustainability:',
        text:
            'Fair limits allow us to maintain and improve the service long-term.',
      ),
    ],
  );
}

Widget buildExceedingLimitsSection() {
  return PolicySection(
    title: 'What Happens If I Exceed Limits?',
    icon: Icons.warning_amber,
    children: [
      PolicyItem(
        text:
            'If you reach your monthly limit, you\'ll receive a notification in the app.',
      ),
      PolicyItem(
        text:
            'Your scan history and Family Mode features remain fully accessible.',
      ),
      PolicyItem(
        text:
            'QR WiFi analysis continues to work unlimited as it\'s processed locally.',
      ),
      PolicyItem(
        text: 'Limits reset automatically on the 1st day of each month.',
      ),
      PolicyItem(
        text:
            'If you consistently need more scans, please contact support to discuss enterprise options.',
      ),
    ],
  );
}

Widget buildMonitoringSection() {
  return PolicySection(
    title: 'Monitoring Your Usage',
    icon: Icons.visibility,
    children: [
      PolicyItem(
        text:
            'View your current usage and remaining scans in Settings → Usage Statistics.',
      ),
      PolicyItem(
        text:
            'The app will notify you when you reach 80% and 100% of your monthly limit.',
      ),
      PolicyItem(
        text: 'Usage counters reset on the 1st of each month at 00:00 UTC.',
      ),
    ],
  );
}

Widget buildPolicyChangesSection() {
  return PolicySection(
    title: 'Policy Changes',
    icon: Icons.update,
    children: [
      PolicyItem(
        text:
            'We reserve the right to adjust usage limits to ensure service quality and sustainability.',
      ),
      PolicyItem(
        text:
            'Existing Premium subscribers will be notified 30 days before any limit reductions.',
      ),
      PolicyItem(
        text:
            'We aim to increase limits as our infrastructure scales and costs decrease.',
      ),
      PolicyItem(text: 'Last updated: October 2025'),
    ],
  );
}

Widget buildContactSupportSection() {
  return PolicySection(
    title: 'Questions or Special Needs?',
    icon: Icons.contact_support,
    children: [
      PolicyItem(
        text:
            'If you have legitimate high-volume scanning needs, contact our support team.',
      ),
      PolicyItem(
        text:
            'Enterprise and business users may qualify for custom plans with higher limits.',
      ),
      PolicyItem(
        text:
            'We\'re happy to work with security researchers and organizations with special requirements.',
      ),
    ],
  );
}
