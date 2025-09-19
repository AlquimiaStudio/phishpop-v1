import 'package:flutter/material.dart';

class HistoryScanItemTitle extends StatelessWidget {
  final String title;
  const HistoryScanItemTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
