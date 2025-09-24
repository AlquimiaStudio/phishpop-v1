import 'package:flutter/material.dart';

import '../../utils/data_utils.dart';
import '../../widgets/widgets.dart';

class ScamLibraryScreen extends StatelessWidget {
  const ScamLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scamScripts = getScamScripts();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: SecondaryAppbar(
        title: 'Scam Library',
        icon: Icons.library_books,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: scamScripts.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        itemBuilder: (context, index) {
          final scam = scamScripts[index];
          return ScamListItem(scam: scam);
        },
      ),
    );
  }
}
