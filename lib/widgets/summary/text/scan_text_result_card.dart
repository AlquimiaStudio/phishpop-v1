import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../widgets.dart';

class ScanTextResultCard extends StatelessWidget {
  final ITextResponse result;

  const ScanTextResultCard({super.key, required this.result});

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
          ScanCardHeader(
            result: result.result,
            classification: result.classification,
            cached: result.cached,
          ),
          const SizedBox(height: 16),
          ScanTextContent(text: result.text),
          const SizedBox(height: 16),
          ScanTextMetrics(result: result),
          const SizedBox(height: 16),
          ScanCardMetadata(
            timestamp: result.timestamp,
            processingTime: result.processingTime,
            scanType: result.scanType,
            normalizedScore: result.normalizedScore,
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
