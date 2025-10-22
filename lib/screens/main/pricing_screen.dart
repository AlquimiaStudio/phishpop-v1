import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../widgets/widgets.dart';
import '../../utils/utils.dart';
import '../../helpers/helpers.dart';
import '../../services/services.dart';
import '../screens.dart';

class PricingScreen extends StatefulWidget {
  final Widget? returnScreen;

  const PricingScreen({super.key, this.returnScreen});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  bool isAnnualSelected = true;
  bool isLoading = true;
  bool isPurchasing = false;

  Package? monthlyPackage;
  Package? annualPackage;

  @override
  void initState() {
    super.initState();
    loadOfferings();
  }

  Future<void> loadOfferings() async {
    try {
      final offerings = await RevenueCatService().getOfferings();

      if (offerings != null && offerings.current != null) {
        setState(() {
          monthlyPackage = RevenueCatService().getPackage(
            offerings,
            RevenueCatService.monthlyPackageId,
          );
          annualPackage = RevenueCatService().getPackage(
            offerings,
            RevenueCatService.annualPackageId,
          );

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> handlePurchase() async {
    if (isPurchasing) return;

    Package? selectedPackage;

    if (isAnnualSelected) {
      selectedPackage = annualPackage;
    } else {
      selectedPackage = monthlyPackage;
    }

    if (selectedPackage == null) {
      GlobalSnackBar.showError(
        context,
        'No package available. Please try again later.',
      );
      return;
    }

    setState(() => isPurchasing = true);

    try {
      final customerInfo = await RevenueCatService().purchasePackage(
        selectedPackage,
      );

      if (!mounted) return;

      setState(() => isPurchasing = false);

      if (customerInfo != null) {
        final isPremium =
            customerInfo
                .entitlements
                .all[RevenueCatService.entitlementId]
                ?.isActive ??
            false;

        if (isPremium) {
          if (!mounted) return;

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withValues(alpha: 0.95),
                      Theme.of(context).primaryColor.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome to Premium!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You now have unlimited access to all premium features',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          navigationWithoutAnimation(
                            context,
                            widget.returnScreen ?? const HomeScreen(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isPurchasing = false);
        GlobalSnackBar.showError(context, 'Purchase failed. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.credit_card,
          title: 'Premium Plans',
          useNavigatorPop: true,
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PricingHeader(),
                  const SizedBox(height: 32),
                  PricingToggle(
                    isAnnualSelected: isAnnualSelected,
                    onToggle: (isAnnual) {
                      setState(() {
                        isAnnualSelected = isAnnual;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  PricingCard(
                    isAnnualSelected: isAnnualSelected,
                    monthlyPackage: monthlyPackage,
                    annualPackage: annualPackage,
                  ),
                  const SizedBox(height: 32),
                  const PricingFeatures(),
                  const SizedBox(height: 32),
                  const FamilyModeHighlight(),
                  const SizedBox(height: 32),
                  const TrustBadges(),
                  const SizedBox(height: 24),
                  PricingCTAButton(
                    onPressed: isPurchasing ? null : handlePurchase,
                    isLoading: isPurchasing,
                  ),
                  const SizedBox(height: 16),
                  const LegalLinks(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
