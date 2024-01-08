import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/data.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/home.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails? details;
  final theme = ThemeController.instance;

  ErrorPage({Key? key, this.details}) : super(key: key);

  String getException() {
    if (details != null) {
      final exception = details?.exceptionAsString();
      if (exception != null) {
        return exception;
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ThemeController.instance.background(),
        title: Text(
          "¡Notifica a UltraBrother!",
          style: TextStyle(color: theme.textPrimary()),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Configure.backgroundLight,
                shape: BoxShape.circle, // Cambiado a una forma circular
              ),
              child: CircleAvatar(
                radius: 150, // Puedes ajustar el radio según tus necesidades
                backgroundImage: AssetImage("assets/ultra_error.jpeg"),
              ),
            ),
            Column(
              children: [
                Text(
                  Constants.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.textPrimary(), fontSize: 25),
                ),
                details != null
                    ? Text(
                        getException(),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Color.fromARGB(255, 255, 221, 0)),
                      )
                    : Container(),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text("Regresar al Inicio"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
