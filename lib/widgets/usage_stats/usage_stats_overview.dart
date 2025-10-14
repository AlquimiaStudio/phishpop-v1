import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../theme/theme.dart';

class UsageStatsOverview extends StatelessWidget {
  final Map<String, UsageStats> allStats;
  final bool isPremium;
  final VoidCallback? onViewDetails;
  final VoidCallback? onUpgrade;

  const UsageStatsOverview({
    super.key,
    required this.allStats,
    required this.isPremium,
    this.onViewDetails,
    this.onUpgrade,
  });

  int get totalScansThisMonth {
    return allStats.values.fold(0, (sum, stats) => sum + stats.currentCount);
  }

  int get totalRemaining {
    if (isPremium) return -1;
    return allStats.values
        .where((stats) => !stats.isUnlimited)
        .fold(0, (sum, stats) => sum + stats.remaining);
  }

  bool get hasAnyLimitReached {
    return allStats.values.any((stats) => stats.isExceeded);
  }

  bool get isNearAnyLimit {
    return allStats.values.any((stats) => stats.isNearLimit);
  }

  DateTime? get nextResetDate {
    final dates = allStats.values
        .where((stats) => stats.resetDate != null)
        .map((stats) => stats.resetDate!)
        .toList();
    if (dates.isEmpty) return null;
    dates.sort();
    return dates.first;
  }

  Color get _statusColor {
    if (isPremium) return AppColors.primaryColor;
    if (hasAnyLimitReached) return AppColors.dangerColor;
    if (isNearAnyLimit) return Colors.orange;
    return AppColors.successColor;
  }

  Color get _backgroundColor {
    if (isPremium) return AppColors.primaryColor.withValues(alpha: 0.1);
    if (hasAnyLimitReached) return AppColors.dangerColor.withValues(alpha: 0.1);
    if (isNearAnyLimit) return Colors.orange.withValues(alpha: 0.1);
    return Colors.grey[100]!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
                child: Icon(Icons.analytics, color: _statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usage Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStatusMessage(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          if (!isPremium && (hasAnyLimitReached || isNearAnyLimit)) ...[
            const SizedBox(height: 16),
            _buildWarningBanner(),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _statusColor),
                    foregroundColor: _statusColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (!isPremium) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onUpgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Upgrade',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusMessage() {
    if (isPremium) {
      return 'Unlimited scans available';
    }
    if (hasAnyLimitReached) {
      return 'Some limits reached this month';
    }
    if (isNearAnyLimit) {
      return 'Approaching monthly limits';
    }
    return 'Track your monthly scan usage';
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.radar,
                label: 'This Month',
                value: totalScansThisMonth.toString(),
                subValue: isPremium ? 'scans' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                icon: Icons.trending_up,
                label: 'Remaining',
                value: isPremium ? '∞' : totalRemaining.toString(),
                subValue: isPremium ? null : 'scans',
              ),
            ),
          ],
        ),
        if (nextResetDate != null) ...[
          const SizedBox(height: 12),
          _buildResetDateInfo(),
        ],
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    String? subValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _statusColor, size: 18),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              if (subValue != null) ...[
                const SizedBox(width: 4),
                Text(
                  subValue,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetDateInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.refresh, color: _statusColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resets on ${DateFormat('MMMM d, yyyy').format(nextResetDate!)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  _getTimeUntilReset(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeUntilReset() {
    if (nextResetDate == null) return '';
    final now = DateTime.now();
    final difference = nextResetDate!.difference(now);

    if (difference.inDays > 1) {
      return 'in ${difference.inDays} days';
    } else if (difference.inDays == 1) {
      return 'tomorrow';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} hours';
    } else {
      return 'very soon';
    }
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasAnyLimitReached
            ? AppColors.dangerColor.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasAnyLimitReached
              ? AppColors.dangerColor.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasAnyLimitReached ? Icons.block : Icons.warning_amber,
            color: hasAnyLimitReached ? AppColors.dangerColor : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasAnyLimitReached
                  ? 'You\'ve reached your limit for some scan types'
                  : 'You\'re approaching your monthly limits',
              style: TextStyle(
                color: hasAnyLimitReached ? AppColors.dangerColor : Colors.orange[800],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
