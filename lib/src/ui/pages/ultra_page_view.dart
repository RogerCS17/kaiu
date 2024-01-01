import 'package:flutter/material.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/ui/pages/ultra_page.dart';

class UltraPageView extends StatefulWidget {
  const UltraPageView({super.key});

  @override
  State<UltraPageView> createState() => _UltraPageViewState();
}

class _UltraPageViewState extends State<UltraPageView> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        children: [
          //Bucle que genera una determinada cantidad de páginas
          //for (int i = 0; i<=2; i++) //En vez de dos debe ser la cantidad de elementos en la colección actual. 
          UltraSelector(ultra: Ultra(name: "@Ultraman", imgPath: "assets/ultraman.jpg", network: false)), //Página Individual. - //Los atributos deben ser traidos de Firebase. 
          UltraSelector(ultra: Ultra(name: "@UltraSeven", imgPath: "assets/ultraseven.jpg", network: false)), //Página Individual. - //Los atributos deben ser traidos de Firebase. 
          UltraSelector(ultra: Ultra(name: "@Ultraman Jack", imgPath: "assets/ultraman_jack.jpg", network: false)), //Página Individual. - //Los atributos deben ser traidos de Firebase. 
        ],
      ),
    );
  }
}