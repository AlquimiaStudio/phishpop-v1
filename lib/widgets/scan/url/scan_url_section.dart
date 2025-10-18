import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../../providers/providers.dart';
import '../../../screens/screens.dart';
import '../../../services/services.dart';
import '../../widgets.dart';

class ScanUrlSection extends StatefulWidget {
  const ScanUrlSection({super.key});

  @override
  State<ScanUrlSection> createState() => _ScanUrlSectionState();
}

class _ScanUrlSectionState extends State<ScanUrlSection> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
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
        sharedContentProvider.contentType == SharedContentType.url &&
        !hasConsumedSharedContent) {
      final content = sharedContentProvider.consumeSharedContent();
      if (content != null) {
        setState(() {
          controller.text = SharedContentDetectorService.normalizeUrl(content);
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
    handleUrlScan() async {
      if (controller.text.isEmpty) return;

      final urlProvider = Provider.of<UrlProvider>(context, listen: false);
      final historyProvider = Provider.of<HistoryProvider>(
        context,
        listen: false,
      );

      final isPremium = await RevenueCatService().isUserPremium();

      if (!isPremium) {
        if (context.mounted) {
          await PremiumUpgradeDialog.show(
            context: context,
            featureName: 'Unlimited URL Scanning',
            description:
                'Scan unlimited URLs and protect yourself from phishing attacks with Premium',
            icon: Icons.language,
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

        String validUrl = validateAndFormatUrl(controller.text)!;

        await urlProvider.analyzeUrl(validUrl, historyProvider);

        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LoadingScreen(
                    icon: Icons.search,
                    title: 'Analyzing...',
                    subtitle: 'Please wait while we scan for threats',
                    screen: UrlSummaryScreen(urlToAnalyze: validUrl),
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
            ScanTitle(title: 'Website URL', icon: Icons.language),
            ScanLabel(
              label: 'Scan URL',
              icon: Icons.language,
              onScanPressed: handleUrlScan,
              isLoading: isLoading,
              isPremium: isPremium,
            ),
          ],
        ),
        SizedBox(height: 20),
        ScanUrlInput(controller: controller),
      ],
    );
  }
}
