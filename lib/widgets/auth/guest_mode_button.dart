import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../services/usage_limits_service.dart';
import '../../theme/theme.dart';

class GuestModeButton extends StatefulWidget {
  const GuestModeButton({super.key});

  @override
  State<GuestModeButton> createState() => _GuestModeButtonState();
}

class _GuestModeButtonState extends State<GuestModeButton> {
  bool isLoading = false;

  Future<void> handleContinueAsGuest() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

      final success = await authProvider.continueAsGuest();

      if (!mounted) return;

      if (!success) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Failed to continue as guest',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Success: Wait explicitly for Firebase auth state stream to update
      // This ensures the AuthWrapper's StreamBuilder receives the new user
      try {
        // Wait for the authStateChanges stream to emit the authenticated user
        // with a 10 second timeout
        await authProvider.authService.authStateChanges
            .firstWhere(
              (user) => user != null && user.isAnonymous,
              orElse: () => throw Exception('Auth state stream timeout'),
            )
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw Exception('Auth state stream timeout'),
            );

        // Pre-load premium status cache before navigation
        try {
          await UsageLimitsService().isPremium();
        } catch (e) {
          // Continue anyway - screens will handle it
        }

        // Give the StreamBuilder a moment to rebuild
        await Future.delayed(const Duration(milliseconds: 300));

        // The loading state will be cleared when this widget is disposed
        // (when navigation occurs) or by the timeout below
      } catch (e) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Authentication succeeded but navigation failed. Please restart the app.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      // Safety timeout: if still mounted and loading after navigation should have occurred
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && isLoading) {
        setState(() {
          isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Signed in successfully. Please restart the app if you don\'t see the home screen.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isLoading ? null : handleContinueAsGuest,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(
                color: AppColors.primaryColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
