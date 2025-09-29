import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class UrlSummaryScreen extends StatefulWidget {
  final String urlToAnalyze;
  final IUrlResponse? analysisResult;
  final bool? isCached;
  final Widget? returnScreen;

  const UrlSummaryScreen({
    super.key,
    required this.urlToAnalyze,
    this.analysisResult,
    this.isCached,
    this.returnScreen,
  });

  @override
  State<UrlSummaryScreen> createState() => _UrlSummaryScreenState();
}

class _UrlSummaryScreenState extends State<UrlSummaryScreen> {
  late UrlProvider urlProvider;

  @override
  void initState() {
    super.initState();
    urlProvider = Provider.of<UrlProvider>(context, listen: false);
  }

  Future<void> refreshData() async {
    if (widget.isCached != null) {
      if (widget.isCached == true) return;
    }

    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    await urlProvider.analyzeUrl(widget.urlToAnalyze, historyProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UrlProvider>(
      builder: (context, urlProvider, child) {
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
                icon: Icons.link,
                title: 'URL Analysis',
                returnScreen: widget.returnScreen,
              ),
              body: Container(
                decoration: getBordersScreen(context),
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  child: widget.analysisResult != null
                      ? ScanUrlResultState(
                          analysisResult: widget.analysisResult!,
                        )
                      : _buildBody(urlProvider),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(UrlProvider urlProvider) {
    if (urlProvider.isLoading) {
      return ScanUrlLoadingState();
    }

    if (urlProvider.error != null) {
      return ScanUrlErrorState(
        error: urlProvider.error!,
        refreshData: refreshData,
      );
    }

    final analysisResult = urlProvider.urlAnalysisResult;
    if (analysisResult == null) {
      return ScanUrlEmptyState();
    }

    return ScanUrlResultState(analysisResult: analysisResult);
  }
}
