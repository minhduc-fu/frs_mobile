import 'package:demo_frs_app/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class FontFamilySen {
  static final String sen = 'Sen';
}

class FontFamilyRoboto {
  static final String roboto = 'Roboto';
}

class TextStyles {
  TextStyles(this.context);
  BuildContext? context;

  static TextStyle defaultStyle = TextStyle(
      fontSize: 14,
      color: ColorPalette.primaryColor,
      fontWeight: FontWeight.w400,
      height: 16 / 14,
      fontFamily: FontFamilyRoboto.roboto);
  static TextStyle h1 = TextStyle(
      fontFamily: FontFamilyRoboto.roboto,
      fontSize: 109.66,
      color: ColorPalette.primaryColor);
  static TextStyle h2 = TextStyle(
      fontFamily: FontFamilyRoboto.roboto,
      fontSize: 67.77,
      color: ColorPalette.primaryColor);
  static TextStyle h3 = TextStyle(
      fontFamily: FontFamilyRoboto.roboto,
      fontSize: 41.89,
      color: ColorPalette.primaryColor);
  static TextStyle h4 = TextStyle(
      fontFamily: FontFamilyRoboto.roboto,
      fontSize: 25.89,
      color: ColorPalette.primaryColor);
  static TextStyle h5 = TextStyle(
      fontFamily: FontFamilyRoboto.roboto,
      fontSize: 16,
      color: ColorPalette.primaryColor);
  static TextStyle h6 = TextStyle(
      fontFamily: FontFamilyRoboto.roboto,
      fontSize: 9.89,
      color: ColorPalette.primaryColor);
}

extension ExtendedTextStyle on TextStyle {
  TextStyle get light {
    return copyWith(fontWeight: FontWeight.w300);
  }

  TextStyle get regular {
    return copyWith(fontWeight: FontWeight.w400);
  }

  TextStyle get italic {
    return copyWith(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic);
  }

  TextStyle get medium {
    return copyWith(fontWeight: FontWeight.w500);
  }

  TextStyle get fontHeader {
    return copyWith(fontSize: 22, height: 22 / 30);
  }

  TextStyle get fontCaption {
    return copyWith(fontSize: 12, height: 12 / 10);
  }

  TextStyle get semibold {
    return copyWith(fontWeight: FontWeight.w600);
  }

  TextStyle get bold {
    return copyWith(fontWeight: FontWeight.w700);
  }

  TextStyle get blackTextColor {
    return copyWith(color: ColorPalette.primaryColor);
  }

  TextStyle get whiteTextColor {
    return copyWith(color: Colors.white);
  }

  //convenience functions
  TextStyle setColor(Color color) {
    return copyWith(color: color);
  }

  TextStyle setTextSize(double size) {
    return copyWith(fontSize: size);
  }
}
