import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color lightScaffoldBackgroundColor = const Color(0xffF9F9F9);
  static Color darkScaffoldBackgroundColor = const Color(0xff2F2E2E);
  static Color secondaryAppColor = const Color(0xff5e92f3);
  static Color secondaryDarkAppColor = Colors.white;
  static Color onColorSurfaceColor = Colors.white;
  static Color onColorSurfaceDarkColor = Colors.black;
}
