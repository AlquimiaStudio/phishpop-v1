import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../exceptions/exceptions.dart';
import '../../../helpers/helpers.dart';
import '../../../providers/providers.dart';
import '../../../screens/screens.dart';
import '../../../services/services.dart';
import '../../widgets.dart';

class ScanTextSection extends StatefulWidget {
  const ScanTextSection({super.key});

  @override
  State<ScanTextSection> createState() => _ScanTextSectionState();
}

class _ScanTextSectionState extends State<ScanTextSection> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  bool hasConsumedSharedContent = false;
  bool isPremium = true;

  @override
  void initState() {
    super.initState();
    checkPremiumStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasConsumedSharedContent) {
      checkSharedContent();
    }
  }

  Future<void> checkPremiumStatus() async {
    final premium = await RevenueCatService().isUserPremium();
    if (mounted) {
      setState(() {
        isPremium = premium;
      });
    }
  }

  void checkSharedContent() {
    final sharedContentProvider = Provider.of<SharedContentProvider>(
      context,
      listen: true,
    );

    if (sharedContentProvider.sharedContent != null &&
        sharedContentProvider.contentType == SharedContentType.text &&
        !hasConsumedSharedContent) {
      final content = sharedContentProvider.consumeSharedContent();
      if (content != null) {
        setState(() {
          controller.text = content;
          hasConsumedSharedContent = true;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleTextScan() async {
      if (controller.text.isEmpty) return;

      final textProvider = Provider.of<TextProvider>(context, listen: false);
      final historyProvider = Provider.of<HistoryProvider>(
        context,
        listen: false,
      );

      final hasInternet = await ConnectivityHelper.hasInternetConnection();
      if (!hasInternet) {
        if (context.mounted) {
          GlobalSnackBar.showError(context, 'No internet connection available');
        }
        return;
      }

      try {
        final usageLimitsService = UsageLimitsService();
        final canScan = await usageLimitsService.canScan('text');

        if (!canScan) {
          return;
        }

        // Show warning dialog when guest has 1 scan remaining (2/3 used)
        final isGuest = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
        if (isGuest) {
          final stats = await usageLimitsService.getUsageStats('total');
          if (stats != null && stats.currentCount == 2) {
            if (context.mounted) {
              await GuestWarningDialog.show(
                context: context,
                scansRemaining: 1,
              );
            }
          }
        }
      } catch (e) {
        if (e is LimitReachedException) {
          if (context.mounted) {
            // Check if user is a guest
            final isGuest = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

            if (isGuest) {
              // Show guest-specific limit reached dialog
              await GuestLimitReachedDialog.show(context: context);
            } else {
              // Show premium upgrade dialog for registered users
              await PremiumUpgradeDialog.show(
                context: context,
                featureName: 'Scan Limit Reached',
                description:
                    'You\'ve reached your limit of 7 scans this month. Upgrade to Premium for unlimited scans.',
                icon: Icons.block,
              );
            }
            controller.clear();
          }
          return;
        }
      }

      setState(() {
        isLoading = true;
      });

      try {
        HapticFeedback.lightImpact();

        String validText = validateAndFormatText(controller.text)!;

        await textProvider.analyzeText(validText, historyProvider);

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LoadingScreen(
                    icon: Icons.search,
                    title: 'Analyzing...',
                    subtitle: 'Please wait while we scan for threats',
                    screen: TextSummaryScreen(textToAnalyze: validText),
                  ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          GlobalSnackBar.showError(context, e.toString());
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScanTitle(title: 'Message or Text', icon: Icons.message),
            ScanLabel(
              label: 'Text Scan',
              icon: Icons.text_fields,
              onScanPressed: handleTextScan,
              isLoading: isLoading,
              isPremium: true,
            ),
          ],
        ),
        SizedBox(height: 20),
        ScanTextInput(controller: controller),
      ],
    );
  }
}
