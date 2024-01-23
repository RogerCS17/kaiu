import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';

class KaijuGaleryImageOnline extends StatelessWidget {
  KaijuGaleryImageOnline({super.key});

  final List<String> imageUrls = [
    'https://i.imgur.com/6S7tIZQ.jpg',
    'https://i.imgur.com/v6cKgbf.jpg',
    'https://i.imgur.com/itloZU1.jpg',
    // Agrega más URL de imágenes según sea necesario
  ];

  final theme = ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        backgroundColor: theme.exBackground(),
        title: Text("Galería Kaiju"),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FullScreenImage(imageUrl: imageUrls[index])));
              },
              child: Card(
                elevation: 3,
                margin: EdgeInsets.all(8.0),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            );
          }),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final theme = ThemeController.instance;

  FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        backgroundColor: theme.exBackground(),
        title: Text('Imagen Completa'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              print("Aquí debería proceder la descarga de la Imagen");
            },
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
