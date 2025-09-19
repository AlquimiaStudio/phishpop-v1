import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class TextSummaryScreen extends StatefulWidget {
  final String textToAnalyze;

  const TextSummaryScreen({super.key, required this.textToAnalyze});

  @override
  State<TextSummaryScreen> createState() => _TextSummaryScreenState();
}

class _TextSummaryScreenState extends State<TextSummaryScreen> {
  late TextProvider textProvider;

  @override
  void initState() {
    super.initState();
    textProvider = Provider.of<TextProvider>(context, listen: false);
  }

  Future<void> analyzeText() async {
    await textProvider.analyzeText(widget.textToAnalyze);
  }

  Future<void> refreshData() async {
    await analyzeText();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TextProvider>(
      builder: (context, textProvider, child) {
        return Container(
          decoration: getAppBackground(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: SecondaryAppbar(icon: Icons.message, title: 'Text Analysis'),
            body: Container(
              decoration: getBordersScreen(context),
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: _buildBody(textProvider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(TextProvider textProvider) {
    if (textProvider.isLoading) {
      return ScanTextLoadingState();
    }

    if (textProvider.error != null) {
      return ScanTextErrorState(
        error: textProvider.error!,
        refreshData: refreshData,
      );
    }

    final analysisResult = textProvider.textAnalysisResult;
    if (analysisResult == null) {
      return ScanTextEmptyState();
    }

    return ScanTextResultState(analysisResult: analysisResult);
  }
}
