import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._();
  static final instance = PreferencesService._();

  //Obtener una Cadena que se guardo como Preferencia
  Future<String> getString(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString(key) ?? "";
  }

  //Setear una Cadena que se guardo como Preferencia
  Future<void> setString(String key, String value) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString(key, value);
  }

  //Obtener un Booleano que se guardo como Preferencia
  Future<bool> getBool(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getBool(key) ?? false;
  }

  //Setear un Booleano que se guardo como Preferencia
  Future<void> setBool(String key, bool value) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setBool(key, value);
  }
}
