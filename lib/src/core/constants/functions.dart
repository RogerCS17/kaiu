  import 'package:flutter/material.dart';
  import 'dart:math';
  
  //Decodifica el Color desde un String
  Color colorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      return Color(int.parse('0xFF$hexColor'));
    } catch (error) {
      return Color.fromARGB(255, 255, 0, 0);
    }
  }

//Genera un Numero Aleatorio del Uno al Nueve
int generateRandomNumberOneToNine() {
  Random random = Random();
  int randomNumber = random.nextInt(9) + 1;
  return randomNumber;
}