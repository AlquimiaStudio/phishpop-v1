import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class ScamLibraryScreen extends StatelessWidget {
  const ScamLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scamScripts = getScamScripts();

    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          title: 'Scam Library',
          icon: Icons.library_books,
          screen: HomeScreen(initialIndex: 3),
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scamScripts.length,
            itemBuilder: (context, index) {
              final scam = scamScripts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: BoxBorder.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ScamListItem(scam: scam),
              );
            },
          ),
        ),
      ),
    );
  }
}
