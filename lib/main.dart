import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/login_page.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
import 'package:kaiu/src/ui/widget/Logo/logo.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.initTheme();
  ErrorWidget.builder =
      (FlutterErrorDetails details) => ErrorPage(details: details);

  // Verifica la conexión a Internet antes de iniciar la aplicación
  if (!await ConnectivityWrapper.instance.isConnected) {
    // No hay conexión, muestra el mensaje y cierra la aplicación
    runApp(_buildNoConnectionApp());
  } else {
    runApp(MyApp());
  }
}

Widget _buildNoConnectionApp() {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: Configure.ultraRedDark,
      body: Center(
        child: AlertDialog(
          title: Text('Sin conexión'),
          content: Text(
              'No hay conexión a Internet. Por favor, revisa tu conexión e inténtalo nuevamente.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Cierra la aplicación
                SystemNavigator.pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.android),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginPage();
          } else {
            return _buildLoadingScreen();
          }
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Configure.ultraRedDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SizedBox(
                        height: 250,
                        child: Image.asset(
                          "assets/kaiju_icon.png",
                        )),
                  ),
                  SpinKitCubeGrid(
                    size: 62,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          // Widget que contiene el logo de tu aplicación
          Logo(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
