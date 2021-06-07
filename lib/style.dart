import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color bgColor = Color(0xFF1E202C);
const Color bgdarkColor = Color(0xFF0E0E12);
const Color lightColor = Color(0xFFAFB6C5);

const titleStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);
const subtitleStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: lightColor,
);

/// Convenience class to access application colors.
abstract class AppColors {
  /// Dark background color.
  static const Color backgroundColor = Color(0xFF191D1F);

  /// Slightly lighter version of [backgroundColor].
  static const Color backgroundFadedColor = Color(0xFF191B1C);

  /// Color used for cards and surfaces.
  static const Color cardColor = Color(0xFF1F2426);

  /// Accent color used in the application.
  static const Color accentColor = Color(0xFFef8354);
}
