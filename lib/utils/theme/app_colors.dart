import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  // static const Color primary = Color(0xFF00897B); // Teal
  // static const Color primaryLight = Color(0xFF4DB6AC);
  // static const Color primaryDark = Color(0xFF00695C);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryLight = Color(0xFF00E5FF);
  static const Color cardBg = Color(0xFF1E1E1E);

  // Secondary Colors
  static const Color secondary = Color(0xFF475569); // Slate
  static const Color secondaryLight = Color(0xFF64748B);
  static const Color secondaryDark = Color(0xFF334155);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // Background Colors
  // static const Color background = Color(0xFFFAFAFA);
  // static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8F9FA);

  // Text Colors
  // static const Color textPrimary = Color(0xFF1E293B);
  // static const Color textSecondary = Color(0xFF64748B);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  //static const Color divider = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFF2C2C2C);
  static const Color fieldBorder = Color(0xFF666666);

  // Special
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primary.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
