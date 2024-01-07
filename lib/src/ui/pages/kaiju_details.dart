import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/ui/pages/home.dart';
import 'package:kaiu/src/ui/widget/ImageChanger/image_changer.dart';
import 'package:kaiu/src/ui/widget/KaijuDrawer/kaiju_drawer.dart';
import 'package:kaiu/src/ui/widget/MoreDetails/more_details_kaiju.dart';

class KaijuDetails extends StatelessWidget {
  
  // Variable para almacenar el enemigo actual.
  final Kaiju kaiju;
  KaijuDetails({required this.kaiju});
  

  @override
  Widget build(BuildContext context) {
    //Variables Reponsive
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    
    double screenHeight = size.height - (statusHeight);
    double screenWidth = size.width;
    final theme = ThemeController.instance;
  
  return Scaffold(
    drawer: KaijuDrawer(kaiju: kaiju,),
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:Colors.white,
        ),
        title: Text(
          kaiju.name, //Nombre del Enemigo
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        backgroundColor: colorFromHex(kaiju.colorHex),
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                // Icono del Ultra en el AppBar
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home())
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 25.0,   // Espacio en la parte superior
                      right: 20.0, // Espacio en la parte derecha
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      height: 45,
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.network("https://firebasestorage.googleapis.com/v0/b/kaiu-8295c.appspot.com/o/UltraImages%2FLogo%2Fultraman_logo.png?alt=media&token=c617b80d-164a-4620-a8be-53d51d21fce8"),
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
      // Menú deslizante (drawer)
      //drawer: KaijuDrawerWidget(enemy: enemy),//
      body: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen del Kaiju con bordes redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                //Usamos este Widget para Elegir las Imágenes a Mostrar.
                height: screenHeight/2.85, //Altura de la Imagen según la Pantalla 
                width : screenWidth, //Ancho de la Imagen según la Pantalla
                child: ImageChanger(kaiju: kaiju), //Cambiar
              ),
            ),
            
            //Espaciado - 1/50 de la Altura de la Pantalla
            SizedBox(height: screenHeight/50,),
            
            // Alias del Kaiju & Subtítulo
            Text(
              'Alias: ${kaiju.subtitle}',
              style: const TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
           
           //Espaciado - 1/50 de la Altura de la Pantalla
            SizedBox(height: screenHeight/50,),
            
            // Descripción Específica del Kaiju
            Container(
              //Dimensiones de la Caja con el Texto "Descripción"
              height: screenHeight/2.85, //Altura de la Imagen según la Pantalla
              width: screenWidth, //Ancho de la Imagen según la Pantalla
              
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 245, 245), //Cambiar
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 255, 255, 255), //Cambiar
                  width: 0.5,
                ),
              ),
              child: Scrollbar(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: 
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                            kaiju.description,
                            style: TextStyle(
                              fontSize: 19,
                              color: Color.fromARGB(255, 97, 97, 97)
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
            
            //Espaciado Estratégico
            Expanded(child: Container()),
            // Detalles adicionales del enemigo
            MoreDetailsKaiju(kaiju: kaiju),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}