import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3>
    with TickerProviderStateMixin {
  late AnimationController fadeController;
  late AnimationController demoController;
  late Animation<double> fadeAnimation;

  bool showDemo = false;
  bool showScore = false;
  bool showRedFlags = false;
  bool showVerdict = false;

  @override
  void initState() {
    super.initState();
    setupAnimations();
  }

  @override
  void dispose() {
    fadeController.dispose();
    demoController.dispose();
    super.dispose();
  }

  void setupAnimations() {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    demoController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    fadeController.forward();

    // Iniciar demo automáticamente después de que aparezca el contenido
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) startDemo();
    });
  }

  void startDemo() {
    setState(() {
      showDemo = true;
    });

    // Secuencia de animación del demo
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => showScore = true);
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => showRedFlags = true);
    });

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) setState(() => showVerdict = true);
    });
  }

  void handleContinue() {
    Navigator.pushReplacementNamed(context, '/auth');
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Progress indicator
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 24,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Headline
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: Text(
                      'Meet Your AI Guardian',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtext
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: Text(
                      'See how AI instantly detects scams',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phone mockup with demo
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.85,
                        minHeight: size.height * 0.45,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Fake phishing message
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.lightText.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.message,
                                      color: AppColors.lightText,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Unknown Number',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'URGENT: Your bank account has been compromised! Click here immediately to secure your funds: bit.ly/secure-now',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.darkText,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // AI Analysis
                          Column(
                            children: [
                              if (!showDemo)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryColor,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Analyzing...',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.mediumText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              // Danger Score
                              if (showScore)
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.dangerColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.dangerColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Danger Score',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.dangerColor,
                                              ),
                                        ),
                                        Text(
                                          '92%',
                                          style: AppTextStyles.displaySmall
                                              .copyWith(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.dangerColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (showRedFlags) const SizedBox(height: 16),

                              // Red Flags
                              if (showRedFlags)
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightBackground,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.lightText.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Red Flags Detected:',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.darkText,
                                              ),
                                        ),
                                        const SizedBox(height: 12),
                                        _RedFlagItem(
                                          icon: Icons.warning_rounded,
                                          text: 'Urgent language',
                                        ),
                                        const SizedBox(height: 8),
                                        _RedFlagItem(
                                          icon: Icons.link_off_rounded,
                                          text: 'Suspicious shortened URL',
                                        ),
                                        const SizedBox(height: 8),
                                        _RedFlagItem(
                                          icon: Icons.security_rounded,
                                          text: 'Fake security threat',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              if (showVerdict) const SizedBox(height: 16),

                              // Verdict
                              if (showVerdict)
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 20 * (1 - value)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.dangerColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.dangerColor
                                              .withValues(alpha: 0.2),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'SCAM',
                                          style: AppTextStyles.displaySmall
                                              .copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Do not respond',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // CTA Button
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: handleContinue,
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
                          'Get Started',
                          style: AppTextStyles.buttonText.copyWith(
                            fontSize: 16,
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
      ),
    );
  }
}

class _RedFlagItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _RedFlagItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.dangerColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.dangerColor,
            ),
          ),
        ),
      ],
    );
  }
}
