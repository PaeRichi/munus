import 'package:flutter/material.dart';

class MunusColors {
  static const background = Color(0xFFF8F6F1);
  static const textMain = Color(0xFF1A1A1A);
  static const textRubric = Color(0xFF8B1A1A);
  static const textDiscrete = Color(0xFF9A9A9A);
  static const textGold = Color(0xFF9A7B3C);
}

class MunusFonts {
  static const display = 'CormorantGaramond';
  static const liturgical = 'SourceSerif4';
  static const ui = 'Inter';
}

class MunusTextStyles {
  static TextStyle bodyText(double fontSize) => TextStyle(
        fontFamily: MunusFonts.liturgical,
        fontSize: fontSize,
        color: MunusColors.textMain,
        height: 1.6,
      );

  static TextStyle response(double fontSize) => TextStyle(
        fontFamily: MunusFonts.liturgical,
        fontSize: fontSize,
        color: MunusColors.textMain,
        height: 1.6,
      );

  static TextStyle rubric(double fontSize) => TextStyle(
        fontFamily: MunusFonts.liturgical,
        fontSize: fontSize - 2,
        color: MunusColors.textRubric,
        fontStyle: FontStyle.italic,
        height: 1.5,
      );

  static TextStyle reference(double fontSize) => TextStyle(
        fontFamily: MunusFonts.ui,
        fontSize: fontSize - 4,
        color: MunusColors.textDiscrete,
        letterSpacing: 0.3,
      );

  static TextStyle sectionTitle(double fontSize) => TextStyle(
        fontFamily: MunusFonts.ui,
        fontSize: fontSize - 1,
        color: MunusColors.textGold,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600,
      );

  static TextStyle responseLabel(double fontSize) => TextStyle(
        fontFamily: MunusFonts.ui,
        fontSize: fontSize - 4,
        color: MunusColors.textDiscrete,
        letterSpacing: 0.5,
      );
}