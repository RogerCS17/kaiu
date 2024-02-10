import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
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

  //Obtener Datos Específicos
  Future<Kaiju> fetchKaijuData(Kaiju document) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Kaiju')
          .doc(document.id)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        // Crea una instancia de Kaiju utilizando el constructor desdeMap
        Kaiju kaiju = Kaiju(
          
          //Reutilizar Datos Cargados Anteriormente
          id: document.id,
          name: document.name,
          img: document.img,
          ultra: document.ultra,
          colorHex: document.colorHex,

          //Datos Cargados de Firebase (Detalles)
          subtitle: data["subtitle"] ?? "-",
          description: data["description"] ?? "-",
          aliasOf: data["aliasOf"] ?? "-",
          height: data["height"] ?? "-",
          weight: data["weight"] ?? "-",
          planet: data["planet"] ?? "-",
          comentary: data["comentary"] ?? "-",
          imgDrawer: data["imgDrawer"] ?? "-",
          kaijuHabs: data["kaijuHabs"] ?? {},
          usersPremium: data["usersPremium"] ?? [],
          vote: data["vote"] ?? 0,
        );

        return kaiju; // Devuelve el objeto Kaiju
      } else {
        return Kaiju();
      }
    } catch (e) {
      return Kaiju();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      body: FutureBuilder<Kaiju>(
        future: fetchKaijuData(kaiju),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un círculo de carga mientras se obtienen los datos
            return Center(
              child: SpinKitCubeGrid(
                size: 75,
                color: ThemeController.instance.exBackground(),
                duration: Duration(milliseconds: 500)
              ),
            );
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si ocurrió algún problema al obtener los datos
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Muestra la información del Kaiju una vez que se haya obtenido
            final kaijuData = snapshot.data!;
            return _buildKaijuDetails(context, kaijuData);
          }
        },
      ),
    );
  }

  Widget _buildKaijuDetails(BuildContext context, Kaiju kaiju) {
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
            ConnectivityWrapper.instance.isConnected.then((isConnected) {
              if (isConnected) {
                Navigator.pop(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ErrorPage(), // Redirige a la página de error
                  ),
                );
              }
            });
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
        actions: const [],
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
                controller:
                    _scrollController, // Asigna el ScrollController al Scrollbar
                child: ListView(
                  controller:
                      _scrollController, // Asigna el ScrollController al ListView
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
