import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/ui/pages/home.dart';
import 'package:kaiu/src/ui/widget/CarruselText/CarrouselText.dart';
import 'package:kaiu/src/ui/widget/ImageChanger/image_changer.dart';
import 'package:kaiu/src/ui/widget/KaijuDrawer/kaiju_drawer.dart';
import 'package:kaiu/src/ui/widget/MoreDetailsDrawer/more_details_kaiju.dart';

class KaijuDetails extends StatelessWidget {
  final Kaiju kaiju;
  final Ultra ultra;
  final theme = ThemeController.instance;

  KaijuDetails({required this.kaiju, required this.ultra});

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height - (statusHeight);
    var screenWidth = size.width;

    return Scaffold(
      drawer: KaijuDrawer(kaiju: kaiju, ultra: ultra),
      backgroundColor: theme.background(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Icono de volver atrás
          onPressed: () {
            Navigator.pop(
                context); // Acción al presionar el botón de volver atrás
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          kaiju.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            colorFromHex(kaiju.colorHex), // Cambio de color del AppBar
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 25.0,
                      right: 20.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white, // Cambio de color del contenedor
                      ),
                      height: 10,
                      width: 10,
                      child: Padding(
                        padding: EdgeInsets.all(8), //REPARAR
                        // child: Image.network(ultra.imgLogo!),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: screenHeight / 2.85,
                    width: screenWidth,
                    child: ImageChanger(kaiju: kaiju),
                  ),
                  CarrouselText(
                      userNames: ["@Dunksman", "@username2", "@username3"])
                ],
              ),
            ),
            SizedBox(height: screenHeight / 50),
            Text(
              'Alias: ${kaiju.subtitle}',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: theme.textPrimary(),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight / 50),
            Container(
              height: screenHeight / 2.85,
              width: screenWidth,
              decoration: BoxDecoration(
                color: theme
                    .backgroundSecondary(), // Cambio de color del contenedor
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
              child: Scrollbar(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            kaiju.description,
                            style: TextStyle(
                              fontSize: 19,
                              color: theme.textPrimary(),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            MoreDetailsKaiju(kaiju: kaiju),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
