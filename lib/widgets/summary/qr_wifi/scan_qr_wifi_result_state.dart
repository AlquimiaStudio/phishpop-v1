import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../models/models.dart';
import '../../widgets.dart';

class ScanQrWifiResultState extends StatelessWidget {
  final QrWifiResponse analysisResult;

  const ScanQrWifiResultState({super.key, required this.analysisResult});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          QrWifiResultCard(result: analysisResult)
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3),
        ],
      ),
    );
  }
}