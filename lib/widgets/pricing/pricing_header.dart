import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class PricingHeader extends StatelessWidget {
  const PricingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.security,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Upgrade to Premium',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.darkText,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Unlock unlimited scam protection and\nexclusive Family Mode features',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.mediumText,
                height: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}