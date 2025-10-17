import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class PricingToggle extends StatelessWidget {
  final bool isAnnualSelected;
  final ValueChanged<bool> onToggle;

  const PricingToggle({
    super.key,
    required this.isAnnualSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: PricingToggleOption(
              title: 'Monthly',
              isSelected: !isAnnualSelected,
              onTap: () => onToggle(false),
            ),
          ),
          Expanded(
            child: PricingToggleOption(
              title: 'Annual',
              isSelected: isAnnualSelected,
              showBadge: true,
              onTap: () => onToggle(true),
            ),
          ),
        ],
      ),
    );
  }
}

class PricingToggleOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool showBadge;
  final VoidCallback onTap;

  const PricingToggleOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Padding(
              padding: title == 'Monthly'
                  ? const EdgeInsets.symmetric(vertical: 10.0)
                  : const EdgeInsets.symmetric(vertical: 0.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : AppColors.mediumText,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (showBadge) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Save 33%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
