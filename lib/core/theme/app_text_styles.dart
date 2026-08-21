import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const displayLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 42,
    height: 1.05,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
  );
  static const displayMedium = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 34,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
  );
  static const headingLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );
  static const headingMedium = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
  static const title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );
  static const bodyLarge = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16,
    height: 1.5,
  );
  static const body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    height: 1.5,
  );
  static const caption = TextStyle(
    color: AppColors.textMuted,
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );
  static const button = TextStyle(
    color: AppColors.controlOnPrimary,
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static const textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headingLarge,
    headlineMedium: headingMedium,
    titleLarge: title,
    bodyLarge: bodyLarge,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: button,
  );
}
