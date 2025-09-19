import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

class AppTextStyles {
  // Display Styles
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  // Headline Styles
  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
  );

  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
  );

  // Title Styles
  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
  );

  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.mediumText,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.mediumText,
  );

  // Label Styles
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkText,
  );

  // AppBar Title Style
  static TextStyle appBarTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Button Text Style
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Small Button Text Style
  static TextStyle smallButtonText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Input Hint Style
  static TextStyle inputHint = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey[400],
  );

  // Dialog Title Style
  static TextStyle dialogTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
  );

  // Snackbar Text Style
  static TextStyle snackbarText = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.white,
  );

  // Navigation Label Styles
  static TextStyle navLabelSelected = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle navLabelUnselected = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Chip Label Style
  static TextStyle chipLabel = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Create complete TextTheme
  static TextTheme get lightTextTheme =>
      GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
      );

  static TextTheme get darkTextTheme => lightTextTheme.apply(
    bodyColor: AppColors.mediumText,
    displayColor: AppColors.darkText,
  );
}
