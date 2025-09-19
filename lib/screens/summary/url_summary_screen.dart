import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class UrlSummaryScreen extends StatefulWidget {
  final String urlToAnalyze;

  const UrlSummaryScreen({super.key, required this.urlToAnalyze});

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

  Future<void> analyzeUrl() async {
    await urlProvider.analyzeUrl(widget.urlToAnalyze);
  }

  Future<void> refreshData() async {
    await analyzeUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UrlProvider>(
      builder: (context, urlProvider, child) {
        return Container(
          decoration: getAppBackground(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: SecondaryAppbar(icon: Icons.link, title: 'URL Analysis'),
            body: Container(
              decoration: getBordersScreen(context),
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: _buildBody(urlProvider),
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
