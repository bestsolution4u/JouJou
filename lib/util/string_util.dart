import 'package:flutter/material.dart';

class StringUtils {

  static Color hexToColor(String code) {
    if (code != null && code.length > 6) return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    else return null;
  }

}