import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String letter;
  const Logo({super.key, this.letter = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(left: 7, right: 7),
          child: Text(
            "Kai",
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(10)),
          child: Text(
            "U",
            style: TextStyle(
                fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
