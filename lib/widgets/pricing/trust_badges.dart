import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../helpers/helpers.dart';

class TrustBadges extends StatelessWidget {
  const TrustBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = getTrustBadges();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: badges
          .map(
            (badge) => TrustBadgeItem(
              icon: badge['icon'] as IconData,
              text: badge['text'] as String,
            ),
          )
          .toList(),
    );
  }
}

class TrustBadgeItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const TrustBadgeItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.infoColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.infoColor, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.mediumText,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
