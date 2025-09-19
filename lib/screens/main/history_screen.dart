import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ScreenHeader(
            title: 'Scan History',
            subtitle: 'Review your previous threat analysis',
            icon: Icons.history,
          ),
          const SizedBox(height: 24),
          // NoResultsMessage(
          //   icon: Icons.history,
          //   title: 'No scan history yet',
          //   subtitle: 'Your analysis results will appear here',
          // ),
          HistoryScanList(),
        ],
      ),
    );
  }
}
