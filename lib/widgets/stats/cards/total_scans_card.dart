import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class TotalScansCard extends StatelessWidget {
  final int totalScans;

  const TotalScansCard({super.key, required this.totalScans});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatHeader(
            title: 'Total Scans',
            icon: Icons.search,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            totalScans.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 36,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            totalScans == 1 ? 'scan performed' : 'scans performed',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.darkText.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
