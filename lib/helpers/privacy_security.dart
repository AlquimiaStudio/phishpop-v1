import 'package:flutter/material.dart';
import '../widgets/privacy_security/security.dart';

Widget buildIntroSection() {
  return PolicySection(
    title: 'Our Commitment',
    icon: Icons.handshake,
    children: [
      PolicyItem(
        text:
            'PhishPop is designed with privacy-first principles. We minimize data collection and prioritize local processing.',
      ),
      PolicyItem(
        text:
            'Most analysis and data storage happens locally on your device, ensuring your information stays private.',
      ),
      PolicyItem(
        text:
            'We only collect essential data required for security analysis and app functionality.',
      ),
    ],
  );
}

Widget buildDataCollectionSection() {
  return PolicySection(
    title: 'Data Collection',
    icon: Icons.data_usage,
    children: [
      PolicyItem(
        title: 'What we collect:',
        text:
            'URLs, text content, and QR codes submitted for security analysis',
      ),
      PolicyItem(
        title: 'What we DO NOT collect:',
        text:
            'Personal files, browsing history, location data, or device information',
      ),
      PolicyItem(
        title: 'Purpose:',
        text:
            'Data is only used for threat detection and improving security analysis',
      ),
      PolicyItem(
        title: 'Retention:',
        text:
            'Analysis data is processed temporarily and not permanently stored',
      ),
    ],
  );
}

Widget buildAuthenticationSection() {
  return PolicySection(
    title: 'Authentication',
    icon: Icons.account_circle,
    children: [
      PolicyItem(
        text:
            'Authentication is handled securely through Firebase Authentication by Google.',
      ),
      PolicyItem(
        text:
            'We only receive basic profile information (email, name) necessary for account management.',
      ),
      PolicyItem(
        text:
            'Your login credentials are never stored on our servers or within the app.',
      ),
      PolicyItem(
        text:
            'Social login data is governed by the respective provider\'s privacy policy.',
      ),
    ],
  );
}

Widget buildLocalStorageSection() {
  return PolicySection(
    title: 'Local Storage',
    icon: Icons.storage,
    children: [
      PolicyItem(
        text:
            'Scan history and results are stored locally on your device using SQLite.',
      ),
      PolicyItem(
        text:
            'This data never leaves your device unless you explicitly share it.',
      ),
      PolicyItem(
        text: 'You can clear this data anytime through the app settings.',
      ),
      PolicyItem(
        text: 'Uninstalling the app permanently removes all local data.',
      ),
    ],
  );
}

Widget buildThirdPartySection() {
  return PolicySection(
    title: 'Third-Party Services',
    icon: Icons.cloud,
    children: [
      PolicyItem(
        title: 'Firebase (Google):',
        text:
            'Authentication and basic analytics. Governed by Google\'s Privacy Policy.',
      ),
      PolicyItem(
        title: 'Security Analysis API:',
        text:
            'URLs and text are sent to our backend for threat analysis via secure HTTPS.',
      ),
      PolicyItem(
        title: 'No advertising:',
        text: 'We do not use advertising networks or tracking services.',
      ),
    ],
  );
}

Widget buildSecuritySection() {
  return PolicySection(
    title: 'Security Measures',
    icon: Icons.lock,
    children: [
      PolicyItem(text: 'All data transmission uses HTTPS encryption.'),
      PolicyItem(
        text: 'Local data is stored using device-level security measures.',
      ),
      PolicyItem(
        text:
            'We follow industry-standard security practices for data handling.',
      ),
      PolicyItem(text: 'Regular security audits and updates are performed.'),
    ],
  );
}

Widget buildLegalDisclaimerSection() {
  return PolicySection(
    title: 'Legal Disclaimer',
    icon: Icons.gavel,
    children: [
      PolicyItem(
        title: 'Service Availability:',
        text:
            'PhishPop is provided "as-is" without warranties. Service availability may vary.',
      ),
      PolicyItem(
        title: 'Limitation of Liability:',
        text:
            'We are not liable for damages arising from use of the app or security analysis results.',
      ),
      PolicyItem(
        title: 'User Responsibility:',
        text:
            'Users are responsible for verifying security analysis results and making informed decisions.',
      ),
      PolicyItem(
        title: 'Jurisdiction:',
        text:
            'This policy is governed by the laws of Canada and applicable US federal laws.',
      ),
      PolicyItem(
        title: 'Changes:',
        text:
            'We reserve the right to update this policy. Users will be notified of significant changes.',
      ),
    ],
  );
}

Widget buildLegalLinksSection() {
  return PolicySection(
    title: 'Legal Documents',
    icon: Icons.description_outlined,
    children: [
      PolicyLinkItem(
        title: 'View Full Privacy Policy',
        url: 'https://www.andressaumet.com/proyectos/phishpop/privacy-policy',
        icon: Icons.privacy_tip_outlined,
      ),
      const SizedBox(height: 4),
      PolicyLinkItem(
        title: 'View Terms of Service',
        url: 'https://www.andressaumet.com/proyectos/phishpop/terms-of-service',
        icon: Icons.gavel_outlined,
      ),
    ],
  );
}

Widget buildContactSection() {
  return PolicySection(
    title: 'Contact Us',
    icon: Icons.contact_support,
    children: [
      PolicyItem(
        text:
            'If you have questions about this Privacy Policy or our data practices, please contact us through the app\'s support section.',
      ),
      PolicyItem(
        text:
            'For data deletion requests or privacy concerns, reach out to our support team.',
      ),
    ],
  );
}
