import 'package:flutter/material.dart';

class ScamListItemRow extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? trailing;

  const ScamListItemRow({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(child: title),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}