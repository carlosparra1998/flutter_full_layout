import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:full_layout_base/app/utils/general_utils.dart';

class L10n {
  static final supportedLocales = [const Locale('es'), const Locale('en')];

  static String getLanguageName(String code) {
    switch (code) {
      case 'es':
        return translate.spanish;
      case 'en':
        return translate.english;
      default:
        return translate.spanish;
    }
  }

  static Flag getFlag({required String code, double? size}) {
    size ??= 10;
    switch (code) {
      case 'es':
        return Flag.fromCode(
          FlagsCode.ES,
          height: size,
          width: size * 1.2,
          fit: BoxFit.fill,
        );
      case 'en':
        return Flag.fromCode(
          FlagsCode.GB,
          height: size,
          width: size * 1.2,
          fit: BoxFit.fill,
        );
      default:
        return Flag.fromCode(
          FlagsCode.ES,
          height: size,
          width: size * 1.2,
          fit: BoxFit.fill,
        );
    }
  }
}
