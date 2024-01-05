import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/data.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/pages/ultra_page_view.dart';
import 'package:kaiu/src/ui/widget/Buttons/simple_button.dart';
import 'package:kaiu/src/ui/widget/Logo/logo.dart';

class Home extends StatelessWidget {
  final themeController = ThemeController.instance;
  final databaseMethod = DatabaseMethods.instance;
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    return ValueListenableBuilder(
        valueListenable: theme.brightness,
        builder: (BuildContext context, value, child) {
          return Scaffold(
            backgroundColor: theme.background(),
            appBar: AppBar(
              //Botones de Acción Barra Superior.
              actions: [
                IconButton(
                    onPressed: () {
                      theme.changeTheme();
                    },
                    icon: theme.brightnessValue
                        ? Icon(Icons.wb_sunny)
                        : Icon(Icons.nightlight_round)),
                IconButton(onPressed: ()async{
                  print(await databaseMethod.getImageUrl("gs://kaiu-8295c.appspot.com/UltraImages/ultraseven.jpg"));
                }, icon: Icon(Icons.document_scanner))
              ],
              //Configuraciones de la Barra Superior
              backgroundColor: theme.background(),
              title: Text(
                "Página Inicio",
                style: TextStyle(color: theme.textPrimary()),
              ),
              iconTheme: IconThemeData(
                color: theme.textPrimary(),
              ),
            ),
            //Cuerpo de la Página.
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Logo(), //Logo Widget
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
                        style:
                            TextStyle(fontSize: 18, color: theme.textPrimary()),
                      )),
                  SimpleButton(
                    //Simple Button Widget
                    title: "Comenzar",
                    onPressed: () {
                      // final DatabaseMethods _databaseMethods =
                      //     DatabaseMethods();
                      // print(await _databaseMethods.getImageUrl(
                      //     "gs://kaiu-8295c.appspot.com/UltraImages/ultraman.jpg"));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UltraPageView()));
                    },
                  ),
                  Container(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      child: Text(
                        Constants.nameYoutuber,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: theme.textPrimary(),
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w100),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
