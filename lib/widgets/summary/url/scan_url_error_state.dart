import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScanUrlErrorState extends StatelessWidget {
  final String error;
  final VoidCallback refreshData;

  const ScanUrlErrorState({
    super.key,
    required this.error,
    required this.refreshData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ).animate().scale(duration: 400.ms),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: refreshData,
              child: Text('Try Again'),
            ).animate().slideY(begin: 0.3, delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
