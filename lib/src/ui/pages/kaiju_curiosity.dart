import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:youtube_shorts/youtube_shorts.dart';

class KaijuCuriosity extends StatefulWidget {
  //Puede ser un Link o "-"
  final String shortLink;
  const KaijuCuriosity({Key? key, required this.shortLink}) : super(key: key);

  @override
  State<KaijuCuriosity> createState() => _KaijuCuriosityState();
}

class _KaijuCuriosityState extends State<KaijuCuriosity> {
  final theme = ThemeController.instance;
  late final ShortsController controller;

  @override
  void initState() {
    super.initState();
    controller = ShortsController(
      settings: ShortsControllerSettings(startWithAutoplay: true),
      youtubeVideoSourceController: VideosSourceController.fromUrlList(
        videoIds: [widget.shortLink],
      ),
    );
  }

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
          widget.shortLink == "-"
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Agrega una imagen o icono curioso y elegante
                      Icon(
                        Icons.videocam_off,
                        size: 80,
                        color: theme.backgroundUltraRed(),
                      ),
                      SizedBox(height: 20),
                      // Texto "Próximamente" con un estilo elegante
                      Text(
                        'No hay video disponible',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.backgroundUltraRed(),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Un mensaje adicional o descripción
                      Text(
                        '@UltraBrother esta trabajando.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : YoutubeShortsPage(
                  controller: controller,
                ),
          //Aquí puedes agregar más widgets para mostrar contenido sobre el fondo
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
