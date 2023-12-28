import 'package:flutter/material.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("@UltraBrother M78")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(child: Text("Ultraman"),),
            ElevatedButton(onPressed: (){print("Hola Mundo");}, child: Text("Boton"))
          ],
        ),
      ),
    );
  }
}