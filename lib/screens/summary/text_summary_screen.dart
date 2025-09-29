import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class TextSummaryScreen extends StatefulWidget {
  final String textToAnalyze;
  final ITextResponse? analysisResult;
  final bool? isCached;
  final Widget? returnScreen;

  const TextSummaryScreen({
    super.key,
    required this.textToAnalyze,
    this.analysisResult,
    this.isCached,
    this.returnScreen,
  });

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

  Future<void> refreshData() async {
    if (widget.isCached != null) {
      if (widget.isCached == true) return;
    }
    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    await textProvider.analyzeText(widget.textToAnalyze, historyProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TextProvider>(
      builder: (context, textProvider, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (widget.returnScreen != null) {
              navigationWithoutAnimation(context, widget.returnScreen!);
            } else {
              navigationWithoutAnimation(context, HomeScreen());
            }
          },
          child: Container(
            decoration: getAppBackground(context),
            child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: SecondaryAppbar(
              icon: Icons.message,
              title: 'Text Analysis',
              returnScreen: widget.returnScreen,
            ),
            body: Container(
              decoration: getBordersScreen(context),
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: widget.analysisResult != null
                    ? ScanTextResultState(
                        analysisResult: widget.analysisResult!,
                      )
                    : _buildBody(textProvider),
              ),
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
