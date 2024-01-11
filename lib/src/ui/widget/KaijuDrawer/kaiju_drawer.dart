import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/kaiju_habs.dart';
import 'package:kaiu/src/ui/widget/KaijuDrawer/kaiju_option_drawer.dart';

//Widget de Barra Lateral para cada Kaiju
class KaijuDrawer extends StatelessWidget {
  // Variable para almacenar el enemigo actual.
  final Kaiju kaiju;
  final Ultra ultra;

  // Constructor que recibe el enemigo.
  KaijuDrawer({required this.kaiju, required this.ultra});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: ultraWhite,
      child: ListView(
        children: [
          // Encabezado del Drawer con la imagen y el nombre del enemigo.
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorFromHex(kaiju.colorHex),
              image: DecorationImage(
                image: NetworkImage(
                    kaiju.imgDrawer), // Reemplaza con la URL de la imagen
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              //Contenedor Padre
              child: Container(
                  decoration: BoxDecoration(
                    color: colorFromHex(kaiju.colorHex).withOpacity(0.75),
                    //Bordes Redondeados del Contenedor.
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6.5),
                    //Texto Hijo con el Nombre del Kaiju
                    child: Text(
                      kaiju.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.start,
                    ), // Coloca aquí el widget hijo
                  )),
            ),
          ),

          // Opciones Desplegadas en el Drawer.
          ListTile(
            // Título del alias oficial del enemigo.
            title: KaijuOptionDrawer(
              color: colorFromHex(kaiju.colorHex),
              text: 'Alias Oficial: ${kaiju.aliasOf}',
            ),
          ),

          // Título de la altura del enemigo.
          ListTile(
            title: KaijuOptionDrawer(
              color: Colors.orange,
              text: 'Altura: ${kaiju.height}',
            ),
          ),

          // Título del peso del enemigo.
          ListTile(
            title: KaijuOptionDrawer(
              color: Colors.green,
              text: 'Peso: ${kaiju.weight}',
            ),
          ),

          // Título del planeta de origen del enemigo.
          ListTile(
            title: KaijuOptionDrawer(
              color: Colors.lightBlueAccent,
              text: 'Planeta de Origen: ${kaiju.planet}',
            ),
            // onTap: () {
            //   // Acción al tocar la opción.
            //   print("prueba");
            // },
          ),

          // Título de las habilidades del enemigo.
          ListTile(
            title: KaijuOptionDrawer(
              color: Colors.red,
              text: 'Habilidades',
              optionColor: Configure.ultraOption,
            ),
            onTap: () {
              // Acción al tocar la opción para mostrar las habilidades.
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KaijuHabs(
                            kaiju: kaiju,
                          )));
            },
          ),

          // Título de las debilidades del enemigo.
          ListTile(
            title: KaijuOptionDrawer(
                color: Colors.purple,
                text: 'Debilidades',
                optionColor: Configure.ultraOption),
            onTap: () {
              // Acción al tocar la opción para mostrar las debilidades.
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => KaijuWeaknessPage(enemy: enemy))
              // );
            },
          ),

          ListTile(
            title: KaijuOptionDrawer(
                color: const Color.fromARGB(255, 252, 227, 2),
                text: 'Galería Online',
                optionColor: Configure.ultraOption),
            onTap: () {
              // Acción al tocar la opción para mostrar las curiosidades.
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => KaijuGaleryImagesOnlinePage(enemy:enemy))
              // );
            },
          ),

          // Fila con botón de comentario y logo del Ultra.
          Container(
              height: 190,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(9.0),
                  // ),
                  image: DecorationImage(
                      image: AssetImage("assets/Land_of_Light.webp",),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.55), BlendMode.dstATop)),
                  color: colorFromHex(kaiju.colorHex)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón para mostrar el comentario.
                  Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Container(
                        width: 127,
                        child: Image.network(
                            //Se actualiza en Ultra Data y se ingresa mediante una llave.
                            ultra.imgUltra ?? "-"),
                      )),

                  Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        top: 10,
                      ),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Configure.ultraRed.withOpacity(0.6),
                            elevation: 5.0,
                          ),
                          onPressed: () {
                            // Script Accionado por el Botón: Mostrar una ventana emergente con el comentario.
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Color(
                                      0xFF737373), // Color de fondo oscuro
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(87, 0, 0, 0),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // Texto del comentario.
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            kaiju.comentary,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        // Botón para cerrar la ventana emergente.
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Cerrar',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          //Identificador del Botón
                          child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: const Icon(
                                IconData(0xe652, fontFamily: 'MaterialIcons'),
                                size: 32,
                                color: Color.fromARGB(255, 244, 243, 243),
                              )))),

                  // Imagen del Ultra con transparencias. .
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     left: 50
                  //   ),
                  //   child: Container(
                  //     width: 127,
                  //     child: Image.asset(
                  //       //Se actualiza en Ultra Data y se ingresa mediante una llave.
                  //       ultraData[enemy.ultra]![0]
                  //     ),
                  //   )
                  // ),
                ],
              )),
              //Expanded(child: Container(color: ,))
        ],
      ),
    );
  }
}
