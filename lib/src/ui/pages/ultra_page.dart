import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/ultra.dart';

class UltraSelector extends StatelessWidget {
  final Ultra? ultra;
  const UltraSelector({super.key, this.ultra});

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
              actions: [
                IconButton(
                    onPressed: () {
                      theme.changeTheme();
                    },
                    icon: theme.brightnessValue
                        ? Icon(Icons.wb_sunny)
                        : Icon(Icons.nightlight_round))
              ],
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
                          1.55, // Mantén la relación de aspecto
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ultra?.network ?? false
                            ? Image.network(ultra?.imgPath ?? "", fit: BoxFit.fill,)
                            : Image.asset(ultra?.imgPath ?? "", fit: BoxFit.fill,)
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      //print("Hola Mundo");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => UltraSelector()),
                      // );
                    },
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
                        fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
