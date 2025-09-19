import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';

class IssuesList extends StatelessWidget {
  final List<String> issues;
  final String result;

  const IssuesList({super.key, required this.issues, required this.result});

  @override
  Widget build(BuildContext context) {
    if (issues.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flagged Issues',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.mediumText,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: issues.asMap().entries.map((entry) {
            final index = entry.key;
            final issue = entry.value;
            return _buildIssueChip(context, issue, index);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIssueChip(BuildContext context, String issue, int index) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          decoration: BoxDecoration(
            color: getCardColor(result).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: getCardColor(result).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(getIssueIcon(issue), size: 16, color: getCardColor(result)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  formatIssueText(issue),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: getCardColor(result),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 100 * index))
        .slideX(begin: 0.3);
  }
}
