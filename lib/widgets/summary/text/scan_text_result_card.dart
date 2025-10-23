import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanTextResultCard extends StatelessWidget {
  final ITextResponse result;

  const ScanTextResultCard({super.key, required this.result});

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
          ScanCardHeader(
            result: result.result,
            classification: result.classification,
            cached: result.cached,
          ),
          const SizedBox(height: 16),
          ScanTextContent(text: result.text),

          // Guest users see limited results
          if (isGuest) ...[
            const SizedBox(height: 24),
            GuestUpgradePrompt(
              message: 'Sign up to see full technical analysis',
              benefits: [
                'Detailed threat metrics',
                'Complete analysis breakdown',
                '7 scans per month',
                'Saved scan history',
              ],
            ),
          ],

          // Registered users see full results
          if (!isGuest) ...[
            const SizedBox(height: 16),
            ScanTextMetrics(result: result),
            const SizedBox(height: 16),
            ScanCardMetadata(
              timestamp: result.timestamp,
              processingTime: result.processingTime,
              scanType: result.scanType,
              normalizedScore: result.normalizedScore,
              classification: result.classification,
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
              const SizedBox(height: 16),
              const EmergencyContactsSection(),
            ],
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => showExplanationModal(context, getTextAnalysisExplanations),
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
