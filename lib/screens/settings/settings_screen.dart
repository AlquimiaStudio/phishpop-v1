import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getAppBackground(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: SecondaryAppbar(
          icon: Icons.settings_suggest_outlined,
          title: 'Settings',
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(
                  title: 'App Settings',
                  subtitle: 'Configure your security preferences',
                  icon: Icons.settings,
                  message: 'Customize the app behavior and security options',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
