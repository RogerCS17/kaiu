import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/data.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 12, right: 12),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20)),
              child: Text(
                Constants.titleApp,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                    
                ),
              ),
            ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 400,
                  maxWidth: 400,
                ),
                child: Image(
                  image: AssetImage("assets/kaijuicon.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left:12, right: 12,bottom: 25),
                child: Text(
                  Constants.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18
                  ),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  print("Hola Mundo");
                },
                child: Text(
                  "Iniciar",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
