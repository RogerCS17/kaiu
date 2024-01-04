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
                    margin: EdgeInsets.all(20.0),
                    elevation: 7,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height /
                          1.55, // Altura fija del Card
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Ajusta según sea necesario
                        child: Image.network(
                          ultra?.imgPath ?? "",
                          fit: BoxFit
                              .cover, // Ajuste para que la imagen llene el Card
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              // Muestra el indicador de carga mientras la imagen se está cargando
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: onPressed,
                    child: Text(
                      "◀ Lista Kaiju ▶",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
            ),
          );
        }));
  }
}
