import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  static final String _androidApiKey =
      dotenv.env['REVENUECAT_ANDROID_API_KEY'] ?? '';
  static final String _iosApiKey =
      dotenv.env['REVENUECAT_IOS_API_KEY'] ?? '';

  static const String monthlyPackageId = '\$rc_monthly';
  static const String annualPackageId = '\$rc_annual';
  static const String launchPackageId = 'launch';

  static const String entitlementId = 'premium';

  bool _isInitialized = false;

  Future<void> initialize({String? userId}) async {
    if (_isInitialized) return;

    try {
      late PurchasesConfiguration configuration;

      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(_androidApiKey);
      } else if (Platform.isIOS) {
        configuration = PurchasesConfiguration(_iosApiKey);
      }

      if (userId != null) {
        configuration = configuration..appUserID = userId;
      }

      await Purchases.configure(configuration);
      await Purchases.setLogLevel(LogLevel.debug);

      _isInitialized = true;
      log('RevenueCat initialized successfully');
    } catch (e) {
      log('Error initializing RevenueCat: $e');
      rethrow;
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();

      if (offerings.current == null) {
        log('No offerings available');
        return null;
      }

      log(
        'Offerings retrieved: ${offerings.current!.availablePackages.length} packages',
      );
      return offerings;
    } catch (e) {
      log('Error getting offerings: $e');
      return null;
    }
  }

  Future<bool> isUserPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final isPremium =
          customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
      log('User is premium: $isPremium');
      return isPremium;
    } catch (e) {
      log('Error checking subscription: $e');
      return false;
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      log('Error getting customer info: $e');
      return null;
    }
  }

  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      log('Purchase successful');
      return customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        log('User cancelled the purchase');
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        log('User is not allowed to make purchases');
      } else if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        log('Product already purchased');
      } else {
        log('Purchase error: ${e.message}');
      }

      return null;
    } catch (e) {
      log('Unknown purchase error: $e');
      return null;
    }
  }

  Future<CustomerInfo?> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      log('Purchases restored successfully');
      return customerInfo;
    } catch (e) {
      log('Error restoring purchases: $e');
      return null;
    }
  }

  Future<void> login(String userId) async {
    try {
      final result = await Purchases.logIn(userId);
      log('User identified: $userId');
      log('User created: ${result.created}');
    } catch (e) {
      log('Error identifying user: $e');
    }
  }

  Future<void> logout() async {
    try {
      await Purchases.logOut();
      log('User logged out');
    } catch (e) {
      log('Error logging out user: $e');
    }
  }

  Package? getPackage(Offerings offerings, String identifier) {
    try {
      final currentOffering = offerings.current;
      if (currentOffering == null) return null;

      return currentOffering.availablePackages.firstWhere(
        (package) => package.identifier == identifier,
      );
    } catch (e) {
      log('Error getting package $identifier: $e');
      return null;
    }
  }

  String getFormattedPrice(Package package) {
    return package.storeProduct.priceString;
  }

  Future<Package?> getMonthlyPackage() async {
    final offerings = await getOfferings();
    if (offerings == null) return null;
    return getPackage(offerings, monthlyPackageId);
  }

  Future<Package?> getAnnualPackage() async {
    final offerings = await getOfferings();
    if (offerings == null) return null;
    return getPackage(offerings, annualPackageId);
  }

  Future<Package?> getLaunchPackage() async {
    final offerings = await getOfferings();
    if (offerings == null) return null;
    return getPackage(offerings, launchPackageId);
  }
}
