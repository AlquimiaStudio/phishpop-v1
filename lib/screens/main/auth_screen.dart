import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import '../../widgets/auth/auth.dart';
import '../screens.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.login;
  AuthState _authState = AuthState.idle;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  void _handleModeChanged(AuthMode mode) {
    if (_authState == AuthState.loading) return;

    setState(() {
      _authMode = mode;
      _errorMessage = null;
    });
    HapticFeedback.lightImpact();
  }

  void _handleFormSubmit() {
    setState(() {
      _authState = AuthState.loading;
      _errorMessage = null;
    });

    HapticFeedback.lightImpact();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _authState = AuthState.success;
        });
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        navigationWithoutAnimation(context, const HomeScreen());
      }
    });
  }

  void _handleSocialLogin(String provider) {
    if (_authState == AuthState.loading) return;

    HapticFeedback.lightImpact();

    setState(() {
      _authState = AuthState.loading;
      _errorMessage = null;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _authState = AuthState.error;
          _errorMessage = '$provider authentication is coming soon!';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

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
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!keyboardVisible) _buildHeader(),
                    const SizedBox(height: 32),
                    _buildAuthCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.security, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to PhishPOP',
              style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Secure your digital world',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 16,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthToggle(
                currentMode: _authMode,
                onModeChanged: _handleModeChanged,
              ),
              const SizedBox(height: 32),
              AuthForm(
                authMode: _authMode,
                authState: _authState,
                errorMessage: _errorMessage,
                onSubmit: _handleFormSubmit,
              ),
              const SizedBox(height: 32),
              AuthSocialButtons(
                isLoading: _authState == AuthState.loading,
                onGooglePressed: () => _handleSocialLogin('Google'),
                onApplePressed: () => _handleSocialLogin('Apple'),
                onGitHubPressed: () => _handleSocialLogin('GitHub'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _authState == AuthState.loading
                    ? null
                    : () => _navigateToHome(),
                child: Text(
                  'Continue as Guest',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
