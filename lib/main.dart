import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kaiu/src/ui/pages/home.dart';
import 'package:kaiu/src/ui/pages/home_obsoleto.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily
      ),
      home: HomeApp(),
    );
  }
}