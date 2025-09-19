import 'package:flutter/material.dart';

import 'theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.dangerColor,
      surface: AppColors.lightBackground,
      surfaceContainerLowest: AppColors.lightSurface,
    ),
    appBarTheme: AppComponents.appBarTheme,
    textTheme: AppTextStyles.lightTextTheme,
    elevatedButtonTheme: AppComponents.elevatedButtonTheme,
    textButtonTheme: AppComponents.textButtonTheme,
    inputDecorationTheme: AppComponents.lightInputDecorationTheme,
    cardTheme: AppComponents.lightCardTheme,
    bottomNavigationBarTheme: AppComponents.lightBottomNavTheme,
    floatingActionButtonTheme: AppComponents.fabTheme,
    chipTheme: AppComponents.chipTheme,
    dialogTheme: AppComponents.dialogTheme,
    snackBarTheme: AppComponents.snackBarTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.dangerColor,
      surfaceContainerLowest: AppColors.darkBackground,
      surface: AppColors.darkSurface,
    ),
    appBarTheme: AppComponents.appBarTheme,
    textTheme: AppTextStyles.darkTextTheme,
    elevatedButtonTheme: AppComponents.elevatedButtonTheme,
    textButtonTheme: AppComponents.textButtonTheme,
    inputDecorationTheme: AppComponents.darkInputDecorationTheme,
    cardTheme: AppComponents.darkCardTheme,
    bottomNavigationBarTheme: AppComponents.darkBottomNavTheme,
    floatingActionButtonTheme: AppComponents.fabTheme,
    chipTheme: AppComponents.chipTheme,
    dialogTheme: AppComponents.dialogTheme,
    snackBarTheme: AppComponents.snackBarTheme,
  );
}
