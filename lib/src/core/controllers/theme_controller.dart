import 'package:flutter/material.dart';
import 'package:kaiu/src/ui/configure.dart';

class ThemeController {
  
  //Constructor Privado
  ThemeController._();
  
  //Instancia por defecto
  static final instance = ThemeController._();
  
  //¿Que es Value Notifier?
  ValueNotifier<bool> brightness = ValueNotifier<bool>(true);

  bool get brightnessValue => brightness.value;

  Color background() =>
      brightnessValue ? Configure.backgroundLight : Configure.backgroundDark;
  
  Color textPrimary() =>
      brightnessValue ? Colors.black : Colors.white;
  
  void changeTheme(){
    brightness.value = !brightness.value;
  }
}