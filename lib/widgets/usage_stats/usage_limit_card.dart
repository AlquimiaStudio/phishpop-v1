import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../theme/theme.dart';

class UsageLimitCard extends StatelessWidget {
  final UsageStats stats;

  const UsageLimitCard({super.key, required this.stats});

  IconData get _scanIcon {
    switch (stats.scanType) {
      case 'text':
        return Icons.text_fields;
      case 'email':
        return Icons.email;
      case 'link':
        return Icons.link;
      case 'qr_url':
        return Icons.qr_code;
      case 'qr_wifi':
        return Icons.wifi;
      default:
        return Icons.analytics;
    }
  }

  String get _scanTypeLabel {
    switch (stats.scanType) {
      case 'text':
        return 'Text Analysis';
      case 'email':
        return 'Email Analysis';
      case 'link':
        return 'Link Analysis';
      case 'qr_url':
        return 'QR URL Analysis';
      case 'qr_wifi':
        return 'QR WiFi Analysis';
      default:
        return stats.scanType;
    }
  }

  Color get _statusColor {
    if (stats.isUnlimited) return AppColors.successColor;
    if (stats.isExceeded) return AppColors.dangerColor;
    if (stats.isNearLimit) return Colors.orange;
    return AppColors.successColor;
  }

  Color get _backgroundColor {
    if (stats.isUnlimited) return AppColors.successColor.withValues(alpha: 0.1);
    if (stats.isExceeded) return AppColors.dangerColor.withValues(alpha: 0.1);
    if (stats.isNearLimit) return Colors.orange.withValues(alpha: 0.1);
    return Colors.grey[100]!;
  }

  String get _usageText {
    if (stats.isUnlimited) {
      return 'Unlimited';
    }
    return '${stats.currentCount} of ${stats.limit} used';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_scanIcon, color: _statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _scanTypeLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _usageText,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              if (!stats.isUnlimited)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${stats.percentage.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (!stats.isUnlimited) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: stats.percentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (stats.remaining > 0)
                  Text(
                    '${stats.remaining} remaining',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  Text(
                    'Limit reached',
                    style: TextStyle(
                      color: AppColors.dangerColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (stats.resetDate != null)
                  Text(
                    'Resets: ${DateFormat('MMM d').format(stats.resetDate!)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.all_inclusive, color: _statusColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  'No limits on this scan type',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (stats.lastScanDate != null) ...[
            const SizedBox(height: 8),
            Text(
              'Last scan: ${_formatLastScanDate(stats.lastScanDate!)}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatLastScanDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
