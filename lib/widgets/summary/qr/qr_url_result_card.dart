import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class QrUrlResultCard extends StatelessWidget {
  final QRUrlResponseModel result;

  const QrUrlResultCard({super.key, required this.result});

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
          ScanCardUrlHeader(result: result.result.name, cached: result.cached),
          const SizedBox(height: 16),
          QrScanCardUrls(
            qrUrl: result.url,
            destinationUrl: result.destinationUrl,
          ),
          const SizedBox(height: 16),
          ConfidenceScoreBar(
            confidenceScore: result.confidenceScore,
            result: result.result.name,
            getDescription: getUrlConfidenceDescription,
          ),
          const SizedBox(height: 16),
          QrScanCardUrlMetrics(result: result),
          const SizedBox(height: 16),
          ScanCardUrlMetadata(
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
          Center(
            child: OutlinedButton.icon(
              onPressed: () =>
                  showExplanationModal(context, getQrUrlAnalysisExplanations),
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
