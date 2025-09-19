import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScanUrlLoadingState extends StatelessWidget {
  const ScanUrlLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ).animate().scale(duration: 600.ms),
          const SizedBox(height: 16),
          Text(
            'Analyzing URL...',
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}
