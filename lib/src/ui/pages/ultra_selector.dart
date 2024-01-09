import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/ultra.dart';

class UltraSelector extends StatelessWidget {
  final Ultra? ultra;
  final Function()? onPressed;
  const UltraSelector({super.key, this.ultra, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    final heightSelector = MediaQuery.of(context).size.height / 1.40;

    return ValueListenableBuilder(
        valueListenable: theme.brightness,
        builder: ((context, value, child) {
          return Scaffold(
            backgroundColor: theme.background(),
            //Teclado sin Dimensión
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              // actions: [
              //   IconButton(
              //       onPressed: () {
              //         theme.changeTheme();
              //       },
              //       icon: theme.brightnessValue
              //           ? Icon(Icons.wb_sunny)
              //           : Icon(Icons.nightlight_round))
              // ],
              backgroundColor: theme.background(),
              title: Text(
                "Selección Ultra",
                style: TextStyle(color: theme.textPrimary()),
              ),
              iconTheme: IconThemeData(
                color: theme.textPrimary(),
              ),
            ),
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    margin: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 10, bottom: 10),
                    elevation: 7,
                    child: SizedBox(
                      height: heightSelector, // Altura fija del Card
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Ajusta según sea necesario
                        child: Image.network(
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // En lugar de un mensaje de error, muestra una imagen de repuesto
                            return Image.asset('assets/test_image.png', fit: BoxFit.cover,);
                          },
                          ultra?.imgPath ?? "", // URL de la imagen principal
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // La imagen principal está cargada
                              return child;
                            } else {
                              // Muestra el Stack con la imagen de respaldo y el CircularProgressIndicator
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: heightSelector,
                                    width: MediaQuery.of(context).size.width,
                                    child: ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                          sigmaX: 5,
                                          sigmaY:
                                              5), // Ajusta la cantidad de desenfoque
                                      child: Image.asset(
                                        'assets/placeholder.jpeg', // Ruta de la imagen de respaldo en tu proyecto
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.3),
                                    height: heightSelector,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: Color.fromARGB(255, 29, 182, 238),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: onPressed,
                        child: Text(
                          "Registros Kaiju",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Text(
                        ultra?.name ?? "",
                        style: TextStyle(
                          color: theme.textPrimary(),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
