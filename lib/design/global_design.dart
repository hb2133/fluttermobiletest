import 'package:flutter/material.dart';

abstract final class GlobalDesign {
  static const Color Ink = Color(0xFF292A27);
  static const Color SoftInk = Color(0xFF72736C);
  static const Color Paper = Color(0xFFF2F0E8);
  static const Color Mist = Color(0xFFE5E6DF);
  static const Color Moss = Color(0xFF6D7565);
  static const Color StoneLight = Color(0xFF8D8E86);
  static const Color Stone = Color(0xFF62645E);
  static const Color StoneDark = Color(0xFF41433F);
  static const Color WarmLight = Color(0xFFD8CFB3);

  static ThemeData get Theme {
    final ColorScheme ColorSchemeValue = ColorScheme.fromSeed(
      seedColor: Moss,
      brightness: Brightness.light,
      surface: Paper,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorSchemeValue,
      scaffoldBackgroundColor: Paper,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Ink,
          fontSize: 30,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
        titleMedium: TextStyle(
          color: Ink,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: SoftInk, fontSize: 15, height: 1.6),
      ),
    );
  }
}
