import 'package:flutter/material.dart';

class ReportGenerateButton extends StatelessWidget {
  final bool isGenerating;
  final VoidCallback onPressed;

  const ReportGenerateButton({
    super.key,
    required this.isGenerating,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isGenerating 
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Icon(
                Icons.copy,
                color: theme.colorScheme.onPrimary,
              ),
        label: Text(
          isGenerating ? 'Generating Report...' : 'Generate & Copy Report',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isGenerating ? null : onPressed,
      ),
    );
  }
}