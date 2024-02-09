import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';

class KaijuCuriosity extends StatelessWidget {
  KaijuCuriosity({super.key});
  final theme = ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Curiosidades",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.backgroundUltraRed(),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Fondo de la imagen
          Image.asset(
            'assets/ultraman_background.webp',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Filtro obscuro
          Container(
            color: Colors.black.withOpacity(0.55),
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Agrega una imagen o icono curioso y elegante
                Icon(
                  Icons.hourglass_empty,
                  size: 80,
                  color: theme.backgroundUltraRed(),
                ),
                SizedBox(height: 20),
                // Texto "Próximamente" con un estilo elegante
                Text(
                  'Próximamente',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.backgroundUltraRed(),
                  ),
                ),
                SizedBox(height: 10),
                // Un mensaje adicional o descripción
                Text(
                  'Estamos trabajando en algo genial.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
