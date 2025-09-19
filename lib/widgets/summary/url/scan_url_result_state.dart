import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../models/models.dart';
import '../../widgets.dart';

class ScanUrlResultState extends StatelessWidget {
  final IUrlResponse analysisResult;
  const ScanUrlResultState({super.key, required this.analysisResult});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(
            title: 'URL Security Check',
            subtitle: 'Safety analysis of the provided URL',
            icon: Icons.security,
          ).animate().fadeIn().slideY(begin: -0.1),
          const SizedBox(height: 24),
          UrlResultCard(
            result: analysisResult,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }
}
