import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/services/database.dart';

class KaijuGaleryImageOnline extends StatefulWidget {
  final Kaiju kaiju;

  KaijuGaleryImageOnline({super.key, required this.kaiju});

  @override
  State<KaijuGaleryImageOnline> createState() => _KaijuGaleryImageOnlineState();
}

class _KaijuGaleryImageOnlineState extends State<KaijuGaleryImageOnline> {
  final theme = ThemeController.instance;
  final database = DatabaseMethods.instance;

  List<String> imageUrls = [];

  // Agrega más URL de imágenes según sea necesario  ];

  @override
  void initState() {
    super.initState();
    //Then - De la Función asíncrona
    database
        .getStorageLinkFiles('GalleryImages/${widget.kaiju.name}/')
        .then((listLinks) {
      //Cambio de Estado. 
      setState(() {
        imageUrls = listLinks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        backgroundColor: colorFromHex(widget.kaiju.colorHex),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Galería Kaiju",
          style: TextStyle(color: Colors.white),
        ),
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
