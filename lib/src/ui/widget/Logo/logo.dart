import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/ui/configure.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    //Traemos una Instancia del Controlador de Tema
    final theme = ThemeController.instance;
    return Row(
      //Filas Centradas
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Texto Simple
        Container(
          padding: EdgeInsets.only(left: 7, right: 7),
          child: Text(
            "Kai",
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary()),
          ),
        ),
        //Texto Bordeado
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              color: Configure.ultraRed, borderRadius: BorderRadius.circular(17)),
          child: Text(
            "U",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
