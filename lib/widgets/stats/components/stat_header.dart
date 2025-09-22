import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class StatHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double? iconSize;

  const StatHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: iconSize ?? 22, color: color),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.darkText,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
