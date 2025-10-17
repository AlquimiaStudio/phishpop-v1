import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../theme/theme.dart';
import '../../helpers/helpers.dart';

class PricingCard extends StatelessWidget {
  final bool isAnnualSelected;
  final Package? monthlyPackage;
  final Package? annualPackage;

  const PricingCard({
    super.key,
    required this.isAnnualSelected,
    this.monthlyPackage,
    this.annualPackage,
  });

  Map<String, String> getPricingFromPackage(Package package, bool isAnnual) {
    final price = package.storeProduct.price;

    final priceParts = price.toStringAsFixed(2).split('.');

    return {
      'price': priceParts[0],
      'cents': '.${priceParts[1]}',
      'period': isAnnual ? 'per year' : 'per month',
      'savings': isAnnual ? 'Normally \$119.88 Save \$39.89 (33% off)' : '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final selectedPackage = isAnnualSelected ? annualPackage : monthlyPackage;

    final pricing = selectedPackage != null
        ? getPricingFromPackage(selectedPackage, isAnnualSelected)
        : getPricingInfo(isAnnualSelected);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.1),
            AppColors.secondaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                pricing['price']!,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  height: 1,
                ),
              ),
              Text(
                pricing['cents']!,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          Text(
            pricing['period']!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.mediumText),
          ),
          if (isAnnualSelected) ...[
            const SizedBox(height: 8),
            Text(
              pricing['savings']!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
