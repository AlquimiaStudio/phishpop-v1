import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class UrlResultCard extends StatelessWidget {
  final IUrlResponse result;

  const UrlResultCard({super.key, required this.result});

  bool get isGuest {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.isAnonymous ?? false;
  }

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

          // Guest users see limited results
          if (isGuest) ...[
            const SizedBox(height: 24),
            GuestUpgradePrompt(
              message: 'Sign up to see full technical analysis',
              benefits: [
                'Detailed security metrics',
                'Complete threat breakdown',
                '3 scans per month',
                'Saved scan history',
              ],
            ),
          ],

          // Registered users see full results
          if (!isGuest) ...[
            const SizedBox(height: 16),
            ScanCardUrlMetrics(result: result),
            const SizedBox(height: 16),
            ScanCardUrlMetadata(
              scanType: result.scanType,
              classification: result.classification,
              time: result.timestamp,
              processingTime: result.processingTime,
            ),
            if (result.flaggedIssues.isNotEmpty) ...[
              const SizedBox(height: 16),
              IssuesList(issues: result.flaggedIssues, result: result.result),
            ],
            if (shouldShowEmergencyContacts(
              result.result,
              result.classification,
              result.flaggedIssues,
            )) ...[
              const SizedBox(height: 20),
              const EmergencyContactsSection(),
            ],
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: () =>
                    showExplanationModal(context, getUrlAnalysisExplanations),
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
          ],

          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
