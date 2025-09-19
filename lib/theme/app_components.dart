import 'package:flutter/material.dart';

import 'theme.dart';

class AppComponents {
  // AppBar Theme
  static AppBarTheme get appBarTheme => AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    titleTextStyle: AppTextStyles.appBarTitle,
  );

  // Elevated Button Theme
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: AppTextStyles.buttonText,
        ),
      );

  // Text Button Theme
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: AppTextStyles.smallButtonText,
    ),
  );

  // Input Decoration Theme
  static InputDecorationTheme get lightInputDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.dangerColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.dangerColor, width: 2),
        ),
        hintStyle: AppTextStyles.inputHint,
      );

  static InputDecorationTheme get darkInputDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        hintStyle: AppTextStyles.inputHint.copyWith(color: Colors.grey[600]),
      );

  // Card Theme
  static CardThemeData get lightCardTheme => CardThemeData(
    elevation: 8,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.all(8),
  );

  static CardThemeData get darkCardTheme => CardThemeData(
    color: AppColors.darkSurface,
    elevation: 8,
    shadowColor: Colors.black.withValues(alpha: 0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get lightBottomNavTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: AppTextStyles.navLabelSelected,
        unselectedLabelStyle: AppTextStyles.navLabelUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      );

  static BottomNavigationBarThemeData get darkBottomNavTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: AppTextStyles.navLabelSelected,
        unselectedLabelStyle: AppTextStyles.navLabelUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      );

  // Floating Action Button Theme
  static FloatingActionButtonThemeData get fabTheme =>
      const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      );

  // Chip Theme
  static ChipThemeData get chipTheme => ChipThemeData(
    backgroundColor: Colors.grey[100]!,
    selectedColor: AppColors.primaryColor.withValues(alpha: 0.2),
    labelStyle: AppTextStyles.chipLabel,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  // Dialog Theme
  static DialogThemeData get dialogTheme => DialogThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    titleTextStyle: AppTextStyles.dialogTitle,
  );

  // Snackbar Theme
  static SnackBarThemeData get snackBarTheme => SnackBarThemeData(
    backgroundColor: AppColors.darkText,
    contentTextStyle: AppTextStyles.snackbarText,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
  );

  static OutlineInputBorder get inputBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
  );

  static OutlineInputBorder get inputFocusBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
  );

  static OutlineInputBorder get authInputBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  );

  static OutlineInputBorder get authFocusInputBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
  );
  static OutlineInputBorder get authErrorInputBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: AppColors.dangerColor, width: 1),
  );
}
