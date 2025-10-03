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

  Package? monthlyPackage;
  Package? annualPackage;
  Package? launchPackage;

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
          launchPackage = RevenueCatService().getPackage(
            offerings,
            RevenueCatService.launchPackageId,
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
    Package? selectedPackage;

    if (isAnnualSelected) {
      selectedPackage = launchPackage ?? annualPackage;
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

    try {
      final customerInfo = await RevenueCatService().purchasePackage(
        selectedPackage,
      );

      if (customerInfo != null) {
        final isPremium =
            customerInfo
                .entitlements
                .all[RevenueCatService.entitlementId]
                ?.isActive ??
            false;

        if (isPremium) {
          if (!mounted) return;
          GlobalSnackBar.showSuccess(
            context,
            'Purchase successful! Welcome to Premium!',
          );

          navigationWithoutAnimation(
            context,
            widget.returnScreen ?? const HomeScreen(),
          );
        }
      }
    } catch (e) {
      if (mounted) {
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
                    launchPackage: launchPackage,
                  ),
                  const SizedBox(height: 32),
                  const PricingFeatures(),
                  const SizedBox(height: 32),
                  const FamilyModeHighlight(),
                  const SizedBox(height: 32),
                  const TrustBadges(),
                  const SizedBox(height: 24),
                  PricingCTAButton(onPressed: handlePurchase),
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
