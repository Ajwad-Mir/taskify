import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1E1E1E);
  static const Color backgroundColor = Color(0xFFF9F9FF);
  static const Color darkBackgroundColor = Color(0xFF232323);
  static const Color primary = Color(0xFFD8771A);
  static const Color textColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFDCDCDC);
  static const Color hintTextColor = Color(0xFFADA4A5);
  static const Color darkHintTextColor = Color(0xFFBBBBBB);
  static const Color borderColor = Color(0xFF95999B);
  static const Color darkBorderColor = Color(0xFF5F5F5F);
  static const Color darkIconColor = Color(0xFFDAD8D8);
  static const Color iconColor = Color(0xFFA1A1A1);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFD8771A),
      Color(0xFF864505),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
