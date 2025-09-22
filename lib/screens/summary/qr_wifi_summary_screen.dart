import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class QrWifiSummaryScreen extends StatefulWidget {
  final String wifiContent;
  final QrWifiResponse? analysisResult;
  final bool? isCached;

  const QrWifiSummaryScreen({
    super.key,
    required this.wifiContent,
    this.analysisResult,
    this.isCached,
  });

  @override
  State<QrWifiSummaryScreen> createState() => _QrWifiSummaryScreenState();
}

class _QrWifiSummaryScreenState extends State<QrWifiSummaryScreen> {
  late QrWifiProvider qrWifiProvider;

  @override
  void initState() {
    super.initState();
    qrWifiProvider = Provider.of<QrWifiProvider>(context, listen: false);
  }

  Future<void> refreshData() async {
    if (widget.isCached != null) {
      if (widget.isCached == true) return;
    }

    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    await qrWifiProvider.analyzeQrWifi(
      widget.wifiContent,
      historyProvider,
      isRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrWifiProvider>(
      builder: (context, qrWifiProvider, child) {
        return Container(
          decoration: getAppBackground(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: SecondaryAppbar(icon: Icons.wifi, title: 'WiFi Analysis'),
            body: Container(
              decoration: getBordersScreen(context),
              child: RefreshIndicator(
                onRefresh: refreshData,
                child: widget.analysisResult != null
                    ? ScanQrWifiResultState(
                        analysisResult: widget.analysisResult!,
                      )
                    : _buildBody(qrWifiProvider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(QrWifiProvider qrWifiProvider) {
    if (qrWifiProvider.isLoading && !qrWifiProvider.isRefreshing) {
      return ScanQrWifiLoadingState();
    }

    if (qrWifiProvider.error != null) {
      return ScanQrWifiErrorState(
        error: qrWifiProvider.error!,
        refreshData: refreshData,
      );
    }

    final analysisResult = qrWifiProvider.qrWifiAnalysisResult;
    if (analysisResult == null) {
      return ScanQrWifiEmptyState();
    }

    return ScanQrWifiResultState(analysisResult: analysisResult);
  }
}
