  import 'package:flutter/material.dart';
  
  Color colorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      return Color(int.parse('0xFF$hexColor'));
    } catch (error) {
      return Color.fromARGB(255, 255, 0, 0);
    }
  }