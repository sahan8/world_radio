import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static const displayLarge = TextStyle(
    fontSize: 42,
    height: 1.05,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
    fontFamily: 'monospace',
  );
  static const displayMedium = TextStyle(
    fontSize: 34,
    height: 1.1,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.6,
    fontFamily: 'monospace',
  );
  static const headingLarge = TextStyle(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    fontFamily: 'monospace',
  );
  static const headingMedium = TextStyle(
    fontSize: 22,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    fontFamily: 'monospace',
  );
  static const title = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );
  static const bodyLarge = TextStyle(fontSize: 16, height: 1.5);
  static const body = TextStyle(fontSize: 14, height: 1.5);
  static const caption = TextStyle(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    fontFamily: 'monospace',
  );
  static const button = TextStyle(
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
