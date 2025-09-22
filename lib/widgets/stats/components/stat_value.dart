import 'package:flutter/material.dart';

class StatValue extends StatelessWidget {
  final String value;
  final String? subtitle;
  final Color color;
  final TextAlign? textAlign;

  const StatValue({
    super.key,
    required this.value,
    this.subtitle,
    required this.color,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Text(
        //   value,
        //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        //     color: color,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   textAlign: textAlign,
        // ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: textAlign,
          ),
        ],
      ],
    );
  }
}
