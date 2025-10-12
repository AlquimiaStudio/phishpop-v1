import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2>
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
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    animationController.forward();
  }

  void handleContinue() {
    Navigator.pushReplacementNamed(context, '/onboarding-3');
  }

  @override
  Widget build(BuildContext context) {
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
                        width: 24,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
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
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Statistics visualization - Large number
                ScaleTransition(
                  scale: scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor.withValues(alpha: 0.9),
                          AppColors.secondaryColor.withValues(alpha: 0.85),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '1 in 4',
                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                            'VICTIMS',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Headline
                SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Text(
                      '1 in 4 Americans Lost\nMoney to Scams Last Year',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
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
                    'Average loss: \$1,200. Don\'t be next.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // Bullet points
                FadeTransition(
                  opacity: fadeAnimation,
                  child: Column(
                    children: [
                      _StatisticItem(
                        icon: Icons.sms_outlined,
                        text: 'Text message scams up 400%',
                        delay: 400,
                      ),
                      const SizedBox(height: 20),
                      _StatisticItem(
                        icon: Icons.email_outlined,
                        text: 'Email phishing at all-time high',
                        delay: 600,
                      ),
                      const SizedBox(height: 20),
                      _StatisticItem(
                        icon: Icons.elderly_outlined,
                        text: 'Seniors lose \$3 billion annually',
                        delay: 800,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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
                        'See How We Help',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 17,
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

class _StatisticItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final int delay;

  const _StatisticItem({
    required this.icon,
    required this.text,
    required this.delay,
  });

  @override
  State<_StatisticItem> createState() => _StatisticItemState();
}

class _StatisticItemState extends State<_StatisticItem>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutBack,
          ),
        );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.text,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
