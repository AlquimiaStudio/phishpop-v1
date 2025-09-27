import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phishpop/widgets/auth/auth_error_message.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../providers/providers.dart';
import '../../theme/theme.dart';

class AuthRegisterForm extends StatefulWidget {
  const AuthRegisterForm({super.key});

  @override
  State<AuthRegisterForm> createState() => _AuthRegisterFormState();
}

class _AuthRegisterFormState extends State<AuthRegisterForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final focusNode0 = FocusNode();
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool showClearNameButton = false;
  bool showClearEmailButton = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {
        showClearNameButton = nameController.text.isNotEmpty;
      });
    });
    emailController.addListener(() {
      setState(() {
        showClearEmailButton = emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleRegister() async {
    HapticFeedback.lightImpact();

    if (formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

      final success = await authProvider.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );

      if (success && mounted) {
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      }
    }
  }

  void clearName() {
    nameController.clear();
    setState(() {
      showClearNameButton = false;
    });
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
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: Validators.validateName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: focusNode0,
                onTapOutside: (_) {
                  focusNode0.unfocus();
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person_outlined),
                  suffixIcon: showClearNameButton
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: 18,
                          ),
                          onPressed: clearName,
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: focusNode1,
                onTapOutside: (_) {
                  focusNode1.unfocus();
                },
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
                validator: Validators.validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: focusNode2,
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

              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                validator: (value) => Validators.validatePasswordConfirmation(
                  value,
                  passwordController.text,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: focusNode3,
                onTapOutside: (_) {
                  focusNode3.unfocus();
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
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
                  onPressed: authProvider.isLoading ? null : handleRegister,
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
                      : Text('Register', style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
