import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/ui/pages/home.dart';
import 'package:kaiu/src/ui/widget/CarrouselText/CarrouselText.dart';
import 'package:kaiu/src/ui/widget/ImageChanger/image_changer.dart';
import 'package:kaiu/src/ui/widget/KaijuDrawer/kaiju_drawer.dart';
import 'package:kaiu/src/ui/widget/MoreDetailsDrawer/more_details_kaiju.dart';

class KaijuDetails extends StatelessWidget {
  final Kaiju kaiju;
  final Ultra ultra;
  final theme = ThemeController.instance;

  KaijuDetails({super.key, required this.kaiju, required this.ultra});

  // Añadir un ScrollController
  final ScrollController _scrollController = ScrollController();

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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
        backgroundColor: colorFromHex(kaiju.colorHex),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 0.45),
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        topLeft: Radius.circular(8.0))),
                width: 120,
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Image.network(
                  ultra.imgLogo!,
                )),
          ),
        ],
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
                  SizedBox(
                    height: screenHeight / 2.85,
                    width: screenWidth,
                    child: ImageChanger(kaiju: kaiju),
                  ),
                  CarrouselText(userNames: kaiju.usersPremium!.cast<String>())
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
                color: theme.backgroundSecondary(),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
              ),
              child: Scrollbar(
                controller: _scrollController, // Asigna el ScrollController al Scrollbar
                child: ListView(
                  controller: _scrollController, // Asigna el ScrollController al ListView
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
