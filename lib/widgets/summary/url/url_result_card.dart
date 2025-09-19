import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../widgets.dart';

class UrlResultCard extends StatelessWidget {
  final IUrlResponse result;

  const UrlResultCard({super.key, required this.result});

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
          ScanCardUrlHeader(result: result.result, cached: result.cached),
          const SizedBox(height: 16),
          ScanCardUrl(url: result.url),
          const SizedBox(height: 16),
          ConfidenceScoreBar(
            confidenceScore: result.confidenceScore,
            result: result.result,
            getDescription: getUrlConfidenceDescription,
          ),
          const SizedBox(height: 16),
          ScanCardUrlMetadata(
            time: result.timestamp,
            processingTime: result.processingTime,
          ),
          if (result.flaggedIssues.isNotEmpty) ...[
            const SizedBox(height: 16),
            IssuesList(issues: result.flaggedIssues, result: result.result),
          ],
        ],
      ),
    );
  }
}
