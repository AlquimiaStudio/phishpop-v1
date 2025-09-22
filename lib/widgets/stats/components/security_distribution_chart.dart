import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class SecurityDistributionChart extends StatelessWidget {
  final Map<String, int> classificationData;

  const SecurityDistributionChart({
    super.key,
    required this.classificationData,
  });

  @override
  Widget build(BuildContext context) {
    final total = classificationData.values.fold(
      0,
      (sum, count) => sum + count,
    );

    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              'Security Classification',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No data available',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final chartHeight = 180.0;
    final barWidth = 40.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Classification',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: chartHeight + 60,
            child: Row(
              children: [
                // Y-axis labels
                Container(
                  width: 30,
                  height: chartHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('100%', style: _axisLabelStyle(context)),
                      Text('75%', style: _axisLabelStyle(context)),
                      Text('50%', style: _axisLabelStyle(context)),
                      Text('25%', style: _axisLabelStyle(context)),
                      Text('0%', style: _axisLabelStyle(context)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Chart area
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: chartHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: classificationData.entries.map((entry) {
                            final percentage = total > 0
                                ? (entry.value / total * 100)
                                : 0.0;
                            final color = _getColorForClassification(entry.key);
                            final barHeight = (percentage / 100) * chartHeight;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Percentage label on top of bar
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                        fontSize: 11,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                // Bar
                                Container(
                                  width: barWidth,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      // X-axis line
                      Container(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      // X-axis labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: classificationData.keys.map((key) {
                          return Container(
                            width: barWidth,
                            child: Text(
                              key,
                              textAlign: TextAlign.center,
                              style: _axisLabelStyle(context),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _axisLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ) ??
        const TextStyle();
  }

  Color _getColorForClassification(String classification) {
    switch (classification) {
      case 'Safe':
        return Colors.green;
      case 'Suspicious':
        return Colors.orange;
      case 'Unsafe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
