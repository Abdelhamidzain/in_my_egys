import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  
  // Primary - Forest Green
  static const Color primary700 = Color(0xFF0F5C4E);
  static const Color primary800 = Color(0xFF0A4A3F);
  static const Color primary900 = Color(0xFF073D34);
  
  // Secondary - Lime Green
  static const Color secondary400 = Color(0xFFA3E635);
  static const Color secondary500 = Color(0xFF84CC16);
  static const Color secondary600 = Color(0xFFB8E986);
  
  // Neutrals - Cream/Beige
  static const Color neutral50 = Color(0xFFFFFEF5);
  static const Color neutral100 = Color(0xFFF5F5DC);
  static const Color neutral200 = Color(0xFFE8E8D0);
  static const Color neutral300 = Color(0xFFD4D4C4);
  static const Color neutral400 = Color(0xFF9CA38B);
  static const Color neutral500 = Color(0xFF6B7058);
  static const Color neutral600 = Color(0xFF4A4E3D);
  static const Color neutral700 = Color(0xFF2D3025);
  static const Color neutral800 = Color(0xFF1A1C15);
  static const Color neutral900 = Color(0xFF0D0E0A);
  
  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Card backgrounds
  static const Color cardLight = Color(0xFFB8E986);
  static const Color cardLightAlt = Color(0xFFD4F4A8);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.light(
        primary: AppColors.primary700,
        onPrimary: Colors.white,
        secondary: AppColors.secondary400,
        onSecondary: AppColors.primary800,
        surface: AppColors.neutral50,
        onSurface: AppColors.primary800,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.neutral100,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary800,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary700,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.neutral300,
          disabledForegroundColor: AppColors.neutral500,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(0, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary800,
          backgroundColor: AppColors.cardLightAlt,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(0, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary700, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(color: AppColors.neutral500),
        hintStyle: TextStyle(color: AppColors.neutral400),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppColors.cardLight,
        labelStyle: TextStyle(color: AppColors.primary800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.neutral300),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary700,
        unselectedItemColor: AppColors.neutral400,
      ),
      dividerTheme: DividerThemeData(color: AppColors.neutral200),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.dark(
        primary: AppColors.secondary400,
        onPrimary: AppColors.primary800,
        secondary: AppColors.secondary600,
        onSecondary: AppColors.primary800,
        surface: AppColors.primary900,
        onSurface: AppColors.neutral100,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.primary800,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary900,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.primary700,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.secondary400,
          foregroundColor: AppColors.primary800,
          disabledBackgroundColor: AppColors.neutral700,
          disabledForegroundColor: AppColors.neutral500,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(0, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary400,
          side: const BorderSide(color: AppColors.secondary400, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(0, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primary900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.neutral600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.neutral600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.secondary400, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(color: AppColors.neutral400),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary900,
        selectedColor: AppColors.secondary400,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary900,
        selectedItemColor: AppColors.secondary400,
        unselectedItemColor: AppColors.neutral500,
      ),
    );
  }
}




