import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../providers/providers.dart';
import '../../theme/theme.dart';
import '../widgets.dart';

class AuthLoginForm extends StatefulWidget {
  const AuthLoginForm({super.key});

  @override
  State<AuthLoginForm> createState() => _AuthLoginFormState();
}

class _AuthLoginFormState extends State<AuthLoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  bool obscurePassword = true;
  bool showClearEmailButton = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        showClearEmailButton = emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    HapticFeedback.lightImpact();

    if (formKey.currentState?.validate() ?? false) {
      // Clear shared content IMMEDIATELY to prevent any auto-navigation
      final sharedContentProvider = Provider.of<SharedContentProvider>(
        context,
        listen: false,
      );
      sharedContentProvider.clearSharedContent();

      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

      final success = await authProvider.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (success && mounted) {
        emailController.clear();
        passwordController.clear();

        // Navigate to home and remove all other routes
        // This forces AuthWrapper to rebuild and show the correct screen
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  void clearEmail() {
    emailController.clear();
    setState(() {
      showClearEmailButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>(
      builder: (context, authProvider, child) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTapOutside: (_) {
                  focusNode1.unfocus();
                },
                focusNode: focusNode1,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: showClearEmailButton
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: 18,
                          ),
                          onPressed: clearEmail,
                          splashRadius: 15,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: AppComponents.authInputBorder,
                  focusedBorder: AppComponents.authFocusInputBorder,
                  errorBorder: AppComponents.authErrorInputBorder,
                  errorMaxLines: 2,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                focusNode: focusNode2,
                validator: Validators.validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onTapOutside: (_) {
                  focusNode2.unfocus();
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: AppComponents.authInputBorder,
                  focusedBorder: AppComponents.authFocusInputBorder,
                  errorBorder: AppComponents.authErrorInputBorder,
                  errorMaxLines: 2,
                ),
              ),

              if (authProvider.errorMessage?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                AuthErrorMessage(errorMessage: authProvider.errorMessage!),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: authProvider.isLoading ? 0 : 4,
                  ),
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text('Login', style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
