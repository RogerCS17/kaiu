import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
import 'package:kaiu/src/ui/pages/home.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ErrorWidget.builder = (FlutterErrorDetails details) => ErrorPage(details: details);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
    ),

    // MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ThemeController.instance.initTheme(),
        builder: (snapshot, context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
            home: Home(),
          );
        });
  }
}
