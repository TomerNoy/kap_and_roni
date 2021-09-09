import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

const darkGreen = Color(0xff264653);
const green = Color(0xff2A9D8F);
const yellow = Color(0xffE9C46A);
const orange = Color(0xffF4A261);
const red = Color(0xffE76F51);
const banana = Color(0xffF4E3B8);
const offWhite = Color(0xffF5F3F6);
const purple = Color(0xff8D86C9);
const blue = Color(0xff0087C1);

/// text theme
final titleStyle = GoogleFonts.ribeye(color: offWhite);
final subStyle = GoogleFonts.zcoolKuaiLe(color: darkGreen);

const shadow = [
  Shadow(blurRadius: 0.3, color: darkGreen),
  Shadow(offset: Offset(3, 3), blurRadius: 10, color: Color(0x88264653))
];

const boxShadow = [
  BoxShadow(
    offset: Offset(3, 3),
    blurRadius: 5,
    color: Color(0x55264653),
    spreadRadius: 1,
  )
];

ThemeData buildTheme() {
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: darkGreen,
    secondary: yellow,
  );

  final base = ThemeData(
    primaryColor: red,
    highlightColor: yellow,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: offWhite,
    toggleButtonsTheme: const ToggleButtonsThemeData(
      color: darkGreen,
      selectedBorderColor: yellow,
      borderColor: yellow,
      fillColor: banana,
      splashColor: banana,
    ),
  );

  return base;
}
