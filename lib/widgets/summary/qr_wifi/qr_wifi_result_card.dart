import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class QrWifiResultCard extends StatelessWidget {
  final QrWifiResponse result;

  const QrWifiResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScanCardWifiHeader(result: result.result.name, cached: result.cached),
          const SizedBox(height: 16),
          QrScanCardWifiInfo(
            ssid: result.ssid,
            securityType: result.securityType.name,
            signalStrength: result.signalStrength,
          ),
          const SizedBox(height: 16),
          ConfidenceScoreBar(
            confidenceScore: result.confidenceScore,
            result: result.result.name,
            getDescription: (score) => getWifiConfidenceDescription(result.confidenceScore),
          ),
          const SizedBox(height: 16),
          QrScanCardWifiMetrics(result: result),
          const SizedBox(height: 16),
          ScanCardWifiMetadata(
            scanType: result.scanType,
            classification: result.classification.name,
            time: result.timestamp,
            processingTime: result.processingTime,
          ),
          if (result.flaggedIssues.isNotEmpty) ...[
            const SizedBox(height: 16),
            IssuesList(
              issues: result.flaggedIssues,
              result: result.result.name,
            ),
          ],
          const SizedBox(height: 16),
          if (result.result == Results.safe) ...[
            QrWifiConnectionButton(result: result),
            const SizedBox(height: 16),
          ],
          Center(
            child: OutlinedButton.icon(
              onPressed: () =>
                  showExplanationModal(context, getQrWifiAnalysisExplanations),
              icon: Icon(Icons.help_outline, size: 18),
              label: Text('What does this mean?'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
