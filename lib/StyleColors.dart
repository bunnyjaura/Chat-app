import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  Color colorText = const Color(0xff444752);

  Color colorTheme = Color.fromRGBO(102, 0, 255, 1);

  Color colorBack = Color.fromRGBO(141, 48, 255, 1);

  TextStyle? mediumText = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: const Color(0xff444752));
  TextStyle? HeadingText = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 27,
      color: const Color(0xff444752));

  LinearGradient themeGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromRGBO(102, 0, 255, 1),
        Color.fromRGBO(199, 94, 252, 1)
      ]);
}
