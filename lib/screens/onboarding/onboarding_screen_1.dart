import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../../services/services.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    setupAnimations();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void setupAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
          ),
        );

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    animationController.forward();
  }

  Future<void> handleGetProtected() async {
    await OnboardingService().completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withValues(alpha: 0.9),
              AppColors.secondaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Sign In link at top
                FadeTransition(
                  opacity: fadeAnimation,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: handleGetProtected,
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Hero illustration - Shield blocking threats
                ScaleTransition(
                  scale: scaleAnimation,
                  child: SizedBox(
                    height: size.height * 0.4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Main shield with gradient
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.successColor,
                                AppColors.successColor.withValues(alpha: 0.8),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.successColor.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.2),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shield_rounded,
                                size: 100,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'PROTECTED',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Floating threat icons - top left
                        Positioned(
                          left: 20,
                          top: 30,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.dangerColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.warning_rounded,
                                color: AppColors.dangerColor,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        // Floating threat icons - top right
                        Positioned(
                          right: 30,
                          top: 50,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.warningColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.error_outline_rounded,
                                color: AppColors.warningColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),

                        // Floating threat icons - bottom left
                        Positioned(
                          left: 40,
                          bottom: 40,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.dangerColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.dangerous_rounded,
                                color: AppColors.dangerColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),

                        // Floating threat icons - bottom right
                        Positioned(
                          right: 20,
                          bottom: 60,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.warningColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.bug_report_rounded,
                                color: AppColors.warningColor,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Headline
                SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Text(
                      'Stop Scammers in\nTheir Tracks',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Subtext
                FadeTransition(
                  opacity: fadeAnimation,
                  child: Text(
                    'AI-powered protection that works instantly',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // CTA Button
                FadeTransition(
                  opacity: fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: handleGetProtected,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryColor,
                        elevation: 8,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Get Protected',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
