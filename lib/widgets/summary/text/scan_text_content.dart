import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';

class ScanTextContent extends StatefulWidget {
  final String text;

  const ScanTextContent({super.key, required this.text});

  @override
  State<ScanTextContent> createState() => _ScanTextContentState();
}

class _ScanTextContentState extends State<ScanTextContent> {
  bool _isExpanded = false;
  static const int _maxCollapsedLength = 200;

  bool get _shouldShowExpansion => widget.text.length > _maxCollapsedLength;
  String get _displayText => 
      _isExpanded || !_shouldShowExpansion
          ? widget.text
          : '${widget.text.substring(0, _maxCollapsedLength)}...';

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Text copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Analyzed Text',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.mediumText,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: _copyToClipboard,
              icon: Icon(
                Icons.copy,
                size: 18,
                color: AppColors.primaryColor,
              ),
              tooltip: 'Copy text',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minHeight: 32,
                minWidth: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: _isExpanded ? 300 : 150,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.grey[50],
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: SelectableText(
                _displayText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Roboto Mono',
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (_shouldShowExpansion) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
              ),
              label: Text(
                _isExpanded ? 'Show Less' : 'Show More',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ).animate().fadeIn(delay: 100.ms),
          ),
        ],
      ],
    ).animate().fadeIn(delay: 300.ms);
  }
}