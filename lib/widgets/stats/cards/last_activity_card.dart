import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class LastActivityCard extends StatelessWidget {
  final Map<String, dynamic> activityData;

  const LastActivityCard({super.key, required this.activityData});

  IconData getScanTypeIcon(String scanType) {
    switch (scanType.toLowerCase()) {
      case 'url':
        return Icons.link;
      case 'text':
        return Icons.text_fields;
      case 'qr_url':
      case 'qr_wifi':
        return Icons.qr_code;
      default:
        return Icons.search;
    }
  }

  String formatTimeAgo(String timeAgo) {
    if (timeAgo == 'No activity') return 'None';
    return timeAgo.replaceAll(' ago', '');
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = activityData['timeAgo'] as String;
    final scanType = activityData['scanType'] as String;
    final hasActivity = timeAgo != 'No activity';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.secondaryColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatHeader(
            title: 'Last Activity',
            icon: Icons.schedule,
            color: AppColors.secondaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            formatTimeAgo(timeAgo),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            hasActivity
                ? '${scanType.toUpperCase()} scan'
                : 'No recent activity',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.darkText.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
