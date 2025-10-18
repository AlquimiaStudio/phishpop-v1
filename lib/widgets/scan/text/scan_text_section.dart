import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

      final isPremium = await RevenueCatService().isUserPremium();

      if (!isPremium) {
        if (context.mounted) {
          await PremiumUpgradeDialog.show(
            context: context,
            featureName: 'Unlimited Text Scanning',
            description:
                'Scan unlimited messages and texts to detect phishing attempts with Premium',
            icon: Icons.message,
          );
          controller.clear();
        }
        return;
      }

      final hasInternet = await ConnectivityHelper.hasInternetConnection();
      if (!hasInternet) {
        if (context.mounted) {
          GlobalSnackBar.showError(context, 'No internet connection available');
        }
        return;
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
              isPremium: isPremium,
            ),
          ],
        ),
        SizedBox(height: 20),
        ScanTextInput(controller: controller),
      ],
    );
  }
}
