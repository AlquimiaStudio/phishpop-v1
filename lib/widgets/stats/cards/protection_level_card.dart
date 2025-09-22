import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../widgets.dart';

class ProtectionLevelCard extends StatelessWidget {
  final Map<String, dynamic> protectionData;

  const ProtectionLevelCard({super.key, required this.protectionData});

  Color getProtectionColor(String classification) {
    switch (classification) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = protectionData['level'] as String;
    final score = protectionData['score'] as double;
    final classification = protectionData['classification'] as String;
    final color = getProtectionColor(classification);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
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
          StatHeader(title: 'Protection', icon: Icons.shield, color: color),
          const SizedBox(height: 12),
          Text(
            level,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            '${score.toStringAsFixed(0)}% average score',
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
