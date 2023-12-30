import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/data.dart';
import 'package:kaiu/src/ui/widget/logo.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Página Inicio"),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Logo(letter: "U"),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 12),
                constraints: BoxConstraints(
                  maxHeight: 325,
                  maxWidth: 325,
                ),
                child: Image(
                  image: AssetImage("assets/kaijuicon.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Text(
                  Constants.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  print("Hola Mundo");
                },
                child: Text(
                  "Comenzar",
                  style: TextStyle(color: Colors.white),
                )),
            Container(
                padding: EdgeInsets.only(left: 12, right: 12, ),
                child: Text(
                  "©UltraBrother M78",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100),
                )),
          ],
        ),
      ),
    );
  }
}
