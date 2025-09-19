import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HistoryScanTitle extends StatelessWidget {
  final int totalScans;

  const HistoryScanTitle({super.key, this.totalScans = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.security_rounded, size: 20, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 8),
        Text(
          'Totals recent scans:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$totalScans',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF3B82F6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }
}
