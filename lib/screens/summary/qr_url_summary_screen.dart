import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class QrUrlSummaryScreen extends StatefulWidget {
  final String urlToAnalyze;

  const QrUrlSummaryScreen({super.key, required this.urlToAnalyze});

  @override
  State<QrUrlSummaryScreen> createState() => _QrUrlSummaryScreenState();
}

class _QrUrlSummaryScreenState extends State<QrUrlSummaryScreen> {
  late QrUrlProvider qrUrlProvider;

  @override
  void initState() {
    super.initState();
    qrUrlProvider = Provider.of<QrUrlProvider>(context, listen: false);
  }

  Future<void> analyzeQrUrl() async {
    await qrUrlProvider.analyzeQrUrl(widget.urlToAnalyze);
  }

  Future<void> refreshData() async {
    await analyzeQrUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrUrlProvider>(
      builder: (context, qrUrlProvider, child) {
        return Container(
          decoration: getAppBackground(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: SecondaryAppbar(
              icon: Icons.qr_code,
              title: 'QR Code Analysis',
            ),
            body: Container(
              decoration: getBordersScreen(context),
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: _buildBody(qrUrlProvider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(QrUrlProvider qrUrlProvider) {
    if (qrUrlProvider.isLoading) {
      return ScanQrUrlLoadingState();
    }

    if (qrUrlProvider.error != null) {
      return ScanQrUrlErrorState(
        error: qrUrlProvider.error!,
        refreshData: refreshData,
      );
    }

    final analysisResult = qrUrlProvider.qrUrlAnalysisResult;
    if (analysisResult == null) {
      return ScanQrUrlEmptyState();
    }

    return ScanQrUrlResultState(analysisResult: analysisResult);
  }
}
