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

  /// Título de sección DENTRO de una celebración (tipo: titulo en el YAML,
  /// ej. "Rito de la bendición — Ritos iniciales"). Deliberadamente
  /// separado de sectionTitle: ese se sigue usando tal cual para los
  /// headers de categoría en la Home ("FRECUENTES", "BENDICIONES"...),
  /// que no fueron parte de este pedido de Producto. Serif editorial en
  /// vez de sans-serif, sin el letterSpacing "de mayúsculas", peso medio
  /// en vez de semibold.
  static TextStyle liturgicalTitle(double fontSize) => TextStyle(
        fontFamily: MunusFonts.display,
        fontSize: fontSize - 2,
        color: MunusColors.textGold,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.2,
      );

  static TextStyle responseLabel(double fontSize) => TextStyle(
        fontFamily: MunusFonts.ui,
        fontSize: fontSize - 4,
        color: MunusColors.textDiscrete,
        letterSpacing: 0.5,
      );
}