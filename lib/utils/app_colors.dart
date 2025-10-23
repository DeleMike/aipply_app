import 'package:flutter/material.dart';

class AppColors {
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kBlack = Color(0xFF000000);
  static const Color kTransparent = Color(0x00000000);
  
  // Core brand
  static const Color kPrimary = Color(0xFF0056B3); // Deep Blue
  static const Color kAccent = Color(0xFFFFC107); // Vibrant Gold

  // Backgrounds & surfaces
  static const Color kBackground = Color(0xFFF0F2F5);
  static const Color kSurface = Color(0xFFFFFFFF);

  // Text & content
  static const Color kTextPrimary = Color(0xFF0A264F);
  static const Color kTextSecondary = Color(0xFF6C7D95);
  static const Color kTextOnPrimary = Color(0xFFFFFFFF);
  static const Color kTextOnAccent = Color(0xFF0A264F);

  // Neutrals
  static const Color kGray100 = Color(0xFFF9FAFB);
  static const Color kGray200 = Color(0xFFF0F2F5);
  static const Color kGray300 = Color(0xFFE5E7EB);
  static const Color kGray400 = Color(0xFFD1D5DB);
  static const Color kGray500 = Color(0xFF9CA3AF);
  static const Color kGray600 = Color(0xFF6C7D95);
  static const Color kGray700 = Color(0xFF4B5563);
  static const Color kGray800 = Color(0xFF374151);
  static const Color kGray900 = Color(0xFF1F2937);

  // Functional
  static const Color kSuccess = Color(0xFF00B14A);
  static const Color kWarning = Color(0xFFFFA500);
  static const Color kError = Color(0xFFD32F2F);

  // Borders, dividers
  static const Color kBorder = Color(0xFFE0E0E0);

  // Brand gradients
  static const Gradient kPrimaryGradient = LinearGradient(
    colors: [Color(0xFF0056B3), Color(0xFF007BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient kGoldGradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
