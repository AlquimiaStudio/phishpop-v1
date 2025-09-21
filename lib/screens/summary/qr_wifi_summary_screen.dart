import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class QrWifiSummaryScreen extends StatefulWidget {
  final String wifiContent;

  const QrWifiSummaryScreen({super.key, required this.wifiContent});

  @override
  State<QrWifiSummaryScreen> createState() => _QrWifiSummaryScreenState();
}

class _QrWifiSummaryScreenState extends State<QrWifiSummaryScreen> {
  late QrWifiProvider qrWifiProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    qrWifiProvider = Provider.of<QrWifiProvider>(context, listen: false);
    analyzeQrWifi();
  }

  Future<void> analyzeQrWifi() async {
    await qrWifiProvider.analyzeQrWifi(widget.wifiContent);
  }

  Future<void> refreshData() async {
    isLoading = true;
    await analyzeQrWifi();
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
                child: _buildBody(qrWifiProvider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(QrWifiProvider qrWifiProvider) {
    if (isLoading) {
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
