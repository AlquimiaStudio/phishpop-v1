import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../../providers/providers.dart';
import '../../../screens/screens.dart';
import '../../widgets.dart';

class ScanUrlSection extends StatefulWidget {
  const ScanUrlSection({super.key});

  @override
  State<ScanUrlSection> createState() => _ScanUrlSectionState();
}

class _ScanUrlSectionState extends State<ScanUrlSection> {
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleUrlScan() async {
      if (controller.text.isEmpty) return;

      setState(() {
        isLoading = true;
      });

      try {
        HapticFeedback.lightImpact();

        String validUrl = validateAndFormatUrl(controller.text)!;

        final urlProvider = Provider.of<UrlProvider>(context, listen: false);
        await urlProvider.analyzeUrl(validUrl);

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
            ),
          ],
        ),
        SizedBox(height: 20),
        ScanUrlInput(controller: controller),
      ],
    );
  }
}
