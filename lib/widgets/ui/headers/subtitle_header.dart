import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubtitleHeader extends StatelessWidget {
  final String subtitle;
  const SubtitleHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0);
  }
}
