import 'package:flutter/material.dart';
import 'package:phishpop/providers/providers.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/ui/generals/confirmation_dialog.dart';

class AccountActionsService {
  static void handleChangePassword(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();
    final userEmail = authProvider.currentUser?.email;
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (userEmail == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Unable to get user email'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          icon: Icons.lock_reset,
          iconColor: Colors.blue,
          title: 'Reset Password',
          content:
              'A password reset email will be sent to $userEmail. Check your email to reset your password. If you don\'t see it, please check your spam folder.',
          confirmText: 'Send Email',
          confirmButtonColor: Colors.blue,
          onConfirm: () async {
            Navigator.of(dialogContext).pop();

            final success = await authProvider.sendPasswordResetEmail(
              userEmail,
            );

            if (success) {
              await authProvider.logout();
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthWrapper()),
                (route) => false,
              );
            } else {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    authProvider.errorMessage ?? 'Failed to send email',
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        );
      },
    );
  }

  static void handleSignOut(BuildContext context) {
    final navigator = Navigator.of(context);
    final authProvider = context.read<AppAuthProvider>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          icon: Icons.logout,
          iconColor: Colors.orange,
          title: 'Sign Out',
          content:
              'Are you sure you want to sign out? You will need to sign in again to access your account.',
          confirmText: 'Sign Out',
          confirmButtonColor: Colors.orange,
          onConfirm: () async {
            Navigator.of(dialogContext).pop();
            await authProvider.logout();
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthWrapper()),
              (route) => false,
            );
          },
        );
      },
    );
  }

  static void handleDeleteAccount(BuildContext context) {
    final navigator = Navigator.of(context);
    final authProvider = context.read<AppAuthProvider>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          icon: Icons.delete_forever,
          iconColor: Colors.red,
          title: 'Delete Account',
          content:
              'This action cannot be undone. All your data will be permanently deleted. Are you sure you want to delete your account?',
          confirmText: 'Delete',
          confirmButtonColor: Colors.red,
          onConfirm: () async {
            Navigator.of(dialogContext).pop();

            await authProvider.deleteAccount();

            await ScanDatabaseService().clearAllScans();
            await PersistentStatsDatabaseService().resetStats();

            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthWrapper()),
              (route) => false,
            );
          },
        );
      },
    );
  }
}
