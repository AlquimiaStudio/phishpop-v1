import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IconHeader extends StatelessWidget {
  final IconData icon;

  const IconHeader({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
    ).animate().scale(delay: 200.ms);
  }
}
