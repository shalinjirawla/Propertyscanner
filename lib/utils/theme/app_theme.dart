import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  // static ThemeData get lightTheme {
  //   return ThemeData(
  //     useMaterial3: true,
  //     brightness: Brightness.light,
  //     colorScheme: ColorScheme.light(
  //       primary: AppColors.primary,
  //       secondary: AppColors.secondary,
  //       tertiary: AppColors.accent,
  //       surface: AppColors.surface,
  //       background: AppColors.background,
  //       error: AppColors.error,
  //       onPrimary: AppColors.textOnPrimary,
  //       onSecondary: AppColors.textOnPrimary,
  //       onSurface: AppColors.textPrimary,
  //       onBackground: AppColors.textPrimary,
  //       onError: AppColors.white,
  //     ),
  //     scaffoldBackgroundColor: AppColors.background,
  //     fontFamily: 'Inter',
  //
  //     // App Bar Theme
  //     appBarTheme: const AppBarTheme(
  //       elevation: 0,
  //       centerTitle: false,
  //       backgroundColor: AppColors.white,
  //       foregroundColor: AppColors.textPrimary,
  //       surfaceTintColor: Colors.transparent,
  //       systemOverlayStyle: SystemUiOverlayStyle.dark,
  //       titleTextStyle: TextStyle(
  //         fontSize: 20,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         fontFamily: 'Inter',
  //       ),
  //     ),
  //
  //     // Text Theme
  //     textTheme: const TextTheme(
  //       displayLarge: TextStyle(
  //         fontSize: 32,
  //         fontWeight: FontWeight.w700,
  //         color: AppColors.textPrimary,
  //         height: 1.2,
  //       ),
  //       displayMedium: TextStyle(
  //         fontSize: 28,
  //         fontWeight: FontWeight.w700,
  //         color: AppColors.textPrimary,
  //         height: 1.2,
  //       ),
  //       displaySmall: TextStyle(
  //         fontSize: 24,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         height: 1.3,
  //       ),
  //       headlineLarge: TextStyle(
  //         fontSize: 22,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         height: 1.3,
  //       ),
  //       headlineMedium: TextStyle(
  //         fontSize: 20,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         height: 1.3,
  //       ),
  //       headlineSmall: TextStyle(
  //         fontSize: 18,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         height: 1.4,
  //       ),
  //       titleLarge: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         height: 1.5,
  //       ),
  //       titleMedium: TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         height: 1.5,
  //       ),
  //       titleSmall: TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.w600,
  //         color: AppColors.textPrimary,
  //         height: 1.5,
  //       ),
  //       bodyLarge: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w400,
  //         color: AppColors.textPrimary,
  //         height: 1.5,
  //       ),
  //       bodyMedium: TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w400,
  //         color: AppColors.textSecondary,
  //         height: 1.5,
  //       ),
  //       bodySmall: TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.w400,
  //         color: AppColors.textTertiary,
  //         height: 1.5,
  //       ),
  //       labelLarge: TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w500,
  //         color: AppColors.textPrimary,
  //         height: 1.5,
  //       ),
  //       labelMedium: TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //         color: AppColors.textSecondary,
  //         height: 1.5,
  //       ),
  //       labelSmall: TextStyle(
  //         fontSize: 10,
  //         fontWeight: FontWeight.w500,
  //         color: AppColors.textTertiary,
  //         height: 1.5,
  //       ),
  //     ),
  //
  //     // Elevated Button Theme
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: AppColors.primary,
  //         foregroundColor: AppColors.white,
  //         elevation: 0,
  //         shadowColor: Colors.transparent,
  //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         textStyle: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           fontFamily: 'Inter',
  //         ),
  //       ),
  //     ),
  //
  //     // Outlined Button Theme
  //     outlinedButtonTheme: OutlinedButtonThemeData(
  //       style: OutlinedButton.styleFrom(
  //         foregroundColor: AppColors.primary,
  //         side: const BorderSide(color: AppColors.border, width: 1.5),
  //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         textStyle: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           fontFamily: 'Inter',
  //         ),
  //       ),
  //     ),
  //
  //     // Text Button Theme
  //     textButtonTheme: TextButtonThemeData(
  //       style: TextButton.styleFrom(
  //         foregroundColor: AppColors.primary,
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         textStyle: const TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w600,
  //           fontFamily: 'Inter',
  //         ),
  //       ),
  //     ),
  //
  //     // Input Decoration Theme
  //     inputDecorationTheme: InputDecorationTheme(
  //       filled: true,
  //       fillColor: AppColors.surface,
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.border, width: 1),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.border, width: 1),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.primary, width: 2),
  //       ),
  //       errorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.error, width: 1),
  //       ),
  //       focusedErrorBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.error, width: 2),
  //       ),
  //       labelStyle: const TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w500,
  //         color: AppColors.textSecondary,
  //         fontFamily: 'Inter',
  //       ),
  //       hintStyle: const TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w400,
  //         color: AppColors.textTertiary,
  //         fontFamily: 'Inter',
  //       ),
  //     ),
  //
  //     // Card Theme
  //     cardTheme: CardThemeData(
  //       elevation: 0,
  //       shadowColor: Colors.transparent,
  //       color: AppColors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //         side: const BorderSide(color: AppColors.border, width: 1),
  //       ),
  //       margin: EdgeInsets.zero,
  //     ),
  //
  //     // Bottom Navigation Bar Theme
  //     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  //       backgroundColor: AppColors.white,
  //       selectedItemColor: AppColors.primary,
  //       unselectedItemColor: AppColors.textTertiary,
  //       type: BottomNavigationBarType.fixed,
  //       elevation: 8,
  //       selectedLabelStyle: TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.w600,
  //         fontFamily: 'Inter',
  //       ),
  //       unselectedLabelStyle: TextStyle(
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //         fontFamily: 'Inter',
  //       ),
  //     ),
  //
  //     // Floating Action Button Theme
  //     floatingActionButtonTheme: FloatingActionButtonThemeData(
  //       backgroundColor: AppColors.primary,
  //       foregroundColor: AppColors.white,
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //     ),
  //
  //     // Divider Theme
  //     dividerTheme: const DividerThemeData(
  //       color: AppColors.divider,
  //       thickness: 1,
  //       space: 1,
  //     ),
  //   );
  // }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        background: AppColors.background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
