import 'package:flutter/material.dart';

class L10n {
  static final all = [const Locale('en'), const Locale('it')];

  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return 'assets/images/en.png';
      case 'it':
        return 'assets/images/it.png';
      default:
        return 'assets/images/it.png';
    }
  }
}
