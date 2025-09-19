import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TitleHeader extends StatelessWidget {
  final String title;

  const TitleHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ).animate().fadeIn().slideX(begin: -0.2, end: 0);
  }
}
