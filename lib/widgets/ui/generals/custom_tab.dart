import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';

class CustomTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final TabController tabController;

  const CustomTab({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 80,
      child: AnimatedBuilder(
        animation: tabController,
        builder: (context, child) {
          bool isSelected = tabController.index == index;

          final iconColor = isSelected
              ? AppColors.primaryColor
              : Colors.grey[600];
          final textColor = isSelected
              ? AppColors.primaryColor
              : Colors.grey[600];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 12 : 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isSelected ? 4 : 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: isSelected ? 27 : 26,
                  ),
                ),
                const SizedBox(height: 1),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: textColor,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ).animate().scale(delay: (index * 100).ms, duration: 400.ms).fadeIn();
        },
      ),
    );
  }
}
