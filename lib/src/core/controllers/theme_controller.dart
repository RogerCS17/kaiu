import 'package:flutter/material.dart';
import 'package:kaiu/src/core/services/preferences_service.dart';
import 'package:kaiu/src/ui/configure.dart';

class ThemeController {
  
  //Constructor Privado
  ThemeController._();

  //Instancia por defecto
  static final instance = ThemeController._();

  //¿Que es Value Notifier?
  ValueNotifier<bool> brightness = ValueNotifier<bool>(true);

  //Getter Bool
  bool get brightnessValue => brightness.value;

  //Métodos que Cambiar el Color Dinámicamente
  Color background() =>
      brightnessValue ? Configure.backgroundLight : Configure.backgroundDark;
  
  Color exBackground() =>
      !brightnessValue ? Configure.backgroundLight : Configure.backgroundDark;

  Color textPrimary() => brightnessValue ? Colors.black : Colors.white;
  
  Color exTextPrimary() => !brightnessValue ? Colors.black : Colors.white;

  Color backgroundSecondary() => brightnessValue
      ? Configure.backgrountLightSecondary
      : Configure.backgroundDarkSecondary;
    
  Color backgroundUltraRed() => brightnessValue
      ? Configure.ultraRed
      : Configure.ultraRedDark;

  //Funcion que permite cambiar de tema entre claro y obscuro
  void changeTheme() async {
    brightness.value = !brightness.value;
    await PreferencesService.instance.setBool("tema", brightness.value);
  }

  //Inicializa el tema que quedó como una preferencia. 
  Future<void> initTheme() async {
    brightness.value = await PreferencesService.instance.getBool("tema");
  }
}
