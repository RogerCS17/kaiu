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
        leading: Icon(Icons.wifi_off, color: theme.textPrimary(),),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: theme.background(),
        title: Text(
          "¡Error de Conexión!",
          style: TextStyle(color: theme.textPrimary()),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Configure.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 150,
                backgroundImage: AssetImage("assets/ultra_error.webp"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              Constants.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.textPrimary(), fontSize: 25),
            ),
            SizedBox(height: 10),
            details != null
                ? Text(
                    getException(),
                    style: TextStyle(color: Colors.amber),
                  )
                : Text(
                    "¡Revisa tu Conexión a Internet!",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("Regresar al Inicio"),
            ),
          ],
        ),
      ),
    );
  }
}
