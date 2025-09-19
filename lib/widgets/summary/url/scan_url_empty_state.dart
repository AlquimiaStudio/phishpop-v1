import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScanUrlEmptyState extends StatelessWidget {
  const ScanUrlEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.link_off,
              size: 64,
              color: Theme.of(context).disabledColor,
            ).animate().scale(duration: 400.ms),
            const SizedBox(height: 16),
            Text(
              'No URL to analyze',
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              'Please provide a URL to analyze',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }
}
