import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/ui/widget/KaijuCard/KaijuCard.dart';


class KaijuHabs extends StatelessWidget {
  final Kaiju kaiju;
  final theme = ThemeController.instance;
  KaijuHabs({super.key, required this.kaiju});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.background(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Habilidades", style: TextStyle(color: Colors.white),),
          backgroundColor: colorFromHex(kaiju.colorHex),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background_card.jpg'), // Reemplaza con la ruta de tu imagen
                  fit: BoxFit
                      .cover, // Ajusta la imagen para cubrir todo el fondo
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 30,
                ),
                itemCount: kaiju.kaijuHabs?.length,
                itemBuilder: (context, index) {
                  return KaijuCard(
                    title: (kaiju.kaijuHabs?.keys)!.toList()[index],
                    description: '-',
                    img: (kaiju.kaijuHabs?.values)!.toList()[index],
                    kaiju: kaiju,
                  );
                },
              ),
            )
          ],
        ));
  }
}
