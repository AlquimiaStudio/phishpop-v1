import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../../widgets/settings/user_profile_section.dart';
import '../../widgets/settings/user_info_card.dart';
import '../../widgets/settings/account_actions_section.dart';
import '../../widgets/settings/settings_menu_section.dart';

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
          useNavigatorPop: true,
        ),
        body: Container(
          decoration: getBordersScreen(context),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenHeader(
                    title: 'Account Settings',
                    subtitle: 'Manage your profile and preferences',
                    icon: Icons.account_circle,
                    message: 'View and update your account information',
                  ),
                  const SizedBox(height: 24),
                  const UserProfileSection(),
                  const SizedBox(height: 20),
                  const UserInfoCard(),
                  const SizedBox(height: 20),
                  const AccountActionsSection(),
                  const SizedBox(height: 20),
                  const SettingsMenuSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
