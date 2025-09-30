import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class QrUrlSummaryScreen extends StatefulWidget {
  final String urlToAnalyze;
  final QRUrlResponseModel? analysisResult;
  final bool? isCached;
  final Widget? returnScreen;

  const QrUrlSummaryScreen({
    super.key,
    required this.urlToAnalyze,
    this.analysisResult,
    this.isCached,
    this.returnScreen,
  });

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

  Future<void> refreshData() async {
    if (widget.isCached != null) {
      if (widget.isCached == true) return;
    }

    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );

    await qrUrlProvider.analyzeQrUrl(widget.urlToAnalyze, historyProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrUrlProvider>(
      builder: (context, qrUrlProvider, child) {
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
                icon: Icons.qr_code,
                title: 'QR Code Analysis',
                returnScreen: widget.returnScreen,
              ),
              body: Container(
                decoration: getBordersScreen(context),
                child: RefreshIndicator(
                  onRefresh: refreshData,
                  child: widget.analysisResult != null
                      ? ScanQrUrlResultState(
                          analysisResult: widget.analysisResult!,
                        )
                      : _buildBody(qrUrlProvider),
                ),
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
