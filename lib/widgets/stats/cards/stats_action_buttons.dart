import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme.dart';
import '../../../helpers/generals.dart';
import 'package:phishpop/providers/providers.dart';

class StatsActionButtons extends StatelessWidget {
  const StatsActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.read<StatsProvider>();
    final historyProvider = context.read<HistoryProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => showExplanationModal(
            context,
            getStatsExplanations,
            customTitle: 'Understanding Your Security Stats',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: BorderSide(
              color: AppColors.primaryColor.withValues(alpha: 0.3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Explain my stats'),
              SizedBox(width: 5),
              Icon(Icons.help_outline, size: 16),
            ],
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Reset Statistics'),
                content: const Text(
                  'This will reset all accumulated statistics and delete your scan history. Are you sure?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Reset',
                      style: TextStyle(color: AppColors.dangerColor),
                    ),
                  ),
                ],
              ),
            );

            if (confirmed ?? false) {
              await historyProvider.clearAllHistory();
              await statsProvider.resetPersistentStats();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Statistics reset successfully'),
                  ),
                );
              }
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reset Stats'),
              SizedBox(width: 5),
              Icon(Icons.refresh, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
