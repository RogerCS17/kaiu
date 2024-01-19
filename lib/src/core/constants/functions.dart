import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//Funcion que valida si un Email tiene una estructura adecuada
bool isValidEmail(String email) {
  // Expresión regular para validar el formato del correo electrónico
  // Esta expresión puede no cubrir todos los casos posibles, pero es un buen punto de partida.
  final RegExp emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
  );

  return emailRegex.hasMatch(email);
}

//Decodifica el Color desde un String
Color colorFromHex(String hexColor) {
  try {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('0xFF$hexColor'));
  } catch (error) {
    return Color.fromARGB(255, 255, 0, 0);
  }
}

//Genera un Numero Aleatorio del Uno al Nueve - Imágenes PlaceHolder
int generateRandomNumberOneToNine() {
  Random random = Random();
  int randomNumber = random.nextInt(9) + 1;
  return randomNumber;
}

// Función para abrir el enlace
void launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'No se pudo abrir el enlace $url';
  }
}
