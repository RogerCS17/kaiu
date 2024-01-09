import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/models/kaiju.dart';

//Botón (+ Detalles) → Simplemente abre del Drawer
class MoreDetailsKaiju extends StatelessWidget {
  final Kaiju kaiju;
  const MoreDetailsKaiju({required this.kaiju});
  
  
  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    var screenWidth = size.width;
    return InkWell(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      customBorder: CircleBorder(),
      child: Container(
        //Controla la Dimensión del Botón "Más Detalles"
        width: screenHeight/15.0,
        height: screenWidth/6.50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorFromHex(kaiju.colorHex).withOpacity(0.85),
        ),
        child: const Icon(
          Icons.menu,
          size: 24,
          color:Colors.white,
        ),
      )
    );
  }
}