import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets.dart';



class ScamOfficialNumbersSection extends StatelessWidget {
  final Map<String, String> officialNumbers;

  const ScamOfficialNumbersSection({super.key, required this.officialNumbers});

  Future<void> _launchPhone(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeader(title: 'Official Numbers'),
        const SizedBox(height: 12),
        ...officialNumbers.entries.map(
          (entry) => ScamListItemRow(
            leading: Icon(
              Icons.phone,
              color: theme.colorScheme.secondary,
              size: 22,
            ),
            title: Text(
              '${entry.key}: ${entry.value}',
              style: theme.textTheme.bodyLarge,
            ),
            trailing: IconButton(
              icon: Icon(Icons.call, color: theme.colorScheme.primary),
              onPressed: () => _launchPhone(entry.value),
            ),
          ),
        ),
      ],
    );
  }
}
