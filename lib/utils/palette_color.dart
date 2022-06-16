import 'package:flutter/material.dart';
class Palette {
  static MaterialColor kToDark = const MaterialColor(
    0xffE1AB3F, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffE1AB3F ),//10%
      100: Color(0xffE1AB3F),//20%
      200: Color(0xffE1AB3F),//30%
      300: Color(0xffE1AB3F),//40%
      400: Color(0xffE1AB3F),//50%
      500: Color(0xffE1AB3F),//60%
      600: Color(0xffE1AB3F),//70%
      700: Color(0xffE1AB3F),//80%
      800: Color(0xffE1AB3F),//90%
      900: Color(0xffE1AB3F),//100%
    },
  );
}