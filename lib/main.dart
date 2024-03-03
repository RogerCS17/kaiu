import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiu/firebase_options.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/login_page.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiu/src/ui/widget/Logo/logo.dart';
import 'package:youtube_shorts/youtube_shorts.dart';
// import 'package:youtube_shorts/youtube_shorts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await ThemeController.instance.initTheme();
  ErrorWidget.builder =
      (FlutterErrorDetails details) => ErrorPage(details: details);

  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    runApp(_buildNoConnectionApp());
  } else {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(MyApp());
    });
  }
}


Future<void> initializeFirebase() async {
  // 1. Inicializa Firebase primero
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  // 2. Luego configura el caché de Firestore
  FirebaseFirestore.instance.settings = Settings(
    cacheSizeBytes: 10485760,
    persistenceEnabled: true,
  );
}

Widget _buildNoConnectionApp() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Configure.ultraRedBackground,
      body: Center(
        child: AlertDialog(
          title: Text('Sin conexión'),
          content: Text(
              'No hay conexión a Internet. Por favor, revisa tu conexión e inténtalo nuevamente.'),
          actions: [
            ElevatedButton(
              onPressed: () {
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
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: FutureBuilder(
        future: initializeFirebase(),
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
      backgroundColor: ThemeController.instance.background(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      65.0), // Ajusta el radio según tus preferencias
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: SizedBox(
                    height: 257,
                    width: 250,
                    child: Image.asset(
                      "assets/kaiju_icon.webp",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: SpinKitCubeGrid(
              size: 75,
              color: ThemeController.instance.exBackground(),
              duration: Duration(milliseconds: 500)
            ),
          ),
          Logo(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
