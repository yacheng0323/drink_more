import 'dart:ui';

import 'package:flutter/material.dart';

extension GradientColor on Color {
  LinearGradient get gradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        this,
        this,
      ],
    );
  }
}

class DrinkMoreColors {
  static const backgroundTopColor = Color(0xff8CBAC5);
  static const backgroundBottomColor = Color(0xffABCDD5);
  static const contentTextColor = Color(0xff2E2E2E);
  static const textFieldTextColor = Color(0xff0079AC);
  static const clearIconColor = Color(0xff0079AC);

  static const gradientBackgroundColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundTopColor,
      backgroundBottomColor,
    ],
  );

  static const buttonBackgroundColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff2FB6CF),
      Color(0xff2CBAD4),
      Color(0xff2290CE),
    ],
  );
}
