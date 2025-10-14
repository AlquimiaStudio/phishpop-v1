import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../../services/services.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  String? selectedUserType;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setupAnimations();
  }

  @override
  void dispose() {
    fadeController.dispose();
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

    fadeController.forward();
  }

  Future<void> handleSelection(String userType) async {
    setState(() {
      selectedUserType = userType;
      isLoading = true;
    });

    // Save personalization
    await OnboardingService().completePersonalization(userType);

    // Small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      // Navigate to home screen
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.05),

                  // Headline
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: Text(
                      'Who Are You Protecting?',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 28,
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
                      'Choose your protection mode',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // User type cards
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: Column(
                      children: [
                        _UserTypeCard(
                          icon: '🙋',
                          title: 'Just Me',
                          description: 'Personal protection for everyday use',
                          userType: 'just_me',
                          isSelected: selectedUserType == 'just_me',
                          isLoading: isLoading && selectedUserType == 'just_me',
                          onTap: () => handleSelection('just_me'),
                        ),
                        const SizedBox(height: 20),
                        _UserTypeCard(
                          icon: '👨‍👩‍👧',
                          title: 'My Family',
                          description:
                              'Protect your loved ones from online threats',
                          userType: 'family',
                          isSelected: selectedUserType == 'family',
                          isLoading: isLoading && selectedUserType == 'family',
                          onTap: () => handleSelection('family'),
                        ),
                        const SizedBox(height: 20),
                        _UserTypeCard(
                          icon: '👵',
                          title: 'My Elderly Parents',
                          description:
                              'Enhanced protection with Safe Parent features',
                          userType: 'elderly_parents',
                          isSelected: selectedUserType == 'elderly_parents',
                          isLoading:
                              isLoading &&
                              selectedUserType == 'elderly_parents',
                          onTap: () => handleSelection('elderly_parents'),
                          isHighlighted: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserTypeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final String userType;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _UserTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.userType,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHighlighted && !isSelected
                ? AppColors.warningColor
                : isSelected
                ? AppColors.primaryColor
                : Colors.white.withValues(alpha: 0.25),
            width: isSelected || isHighlighted ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.25),
                    blurRadius: 24,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ]
              : isHighlighted && !isSelected
              ? [
                  BoxShadow(
                    color: AppColors.warningColor.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 36)),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Description
                        Text(
                          description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 14,
                            height: 1.4,
                            color: isSelected
                                ? AppColors.mediumText
                                : Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Selection indicator / Loading
                  if (isLoading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isSelected ? AppColors.primaryColor : Colors.white,
                        ),
                      ),
                    )
                  else if (isSelected)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  else
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),

            // Recommended badge
            if (isHighlighted && !isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warningColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warningColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'POPULAR',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
