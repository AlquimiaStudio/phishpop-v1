import 'package:flutter/material.dart';

import 'header.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? message;
  final Color? messageColor;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.message,
    this.messageColor,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconHeader(icon: icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleHeader(title: title),
                  const SizedBox(height: 4),
                  SubtitleHeader(subtitle: subtitle),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (message != null && message!.length > 1)
          InfoHeaderMessage(
            message: message!,
            color: messageColor,
            onActionPressed: onActionPressed,
            actionLabel: actionLabel,
          ),
      ],
    );
  }
}
