import 'package:flutter/widgets.dart';

class AppTextStyles {
  AppTextStyles._();
  
  static const String kFontFamily = 'Poppins';
  
  static const thin = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w100,
  );

  static const extraLight = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w200,
  );

  static const light = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w300,
  );

  static const normal = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w400,
  );

  static const medium = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w500,
  );

  static const semiBold = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w600,
  );

  static const bold = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w700,
  );

  static const extraBold = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w800,
  );

  static const black = TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.w900,
  );
}
