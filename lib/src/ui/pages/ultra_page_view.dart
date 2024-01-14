import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/kaiju_galery.dart';
import 'package:kaiu/src/ui/pages/ultra_selector.dart';

class UltraPageView extends StatefulWidget {
  const UltraPageView({super.key});

  @override
  State<UltraPageView> createState() => _UltraPageViewState();
}

class _UltraPageViewState extends State<UltraPageView> {
  final PageController _pageController = PageController(
    viewportFraction: 0.82,
  );

  //Variables que Obtendrán el Número de Página Actual
  int _currentPageFake = 0;
  int _currentPageReal = 0;

  final databaseMethod = DatabaseMethods.instance;
  final theme = ThemeController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        title: Text(
          "Selector Ultra",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Configure.ultraRed,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: false, //Teclado sin Dimensión
      body: StreamBuilder(
        stream: databaseMethod.getUltraDetails(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Ultra> ultras = snapshot.data!.docs.map((doc) {
              // Mapear cada documento a un objeto Ultra
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Ultra(
                name: data['name'],
                imgPath: data["imgPath"],
                imgLogo: data["imgLogo"],
                imgUltra: data["imgUltra"],
                // Agrega otros atributos según tu modelo Ultra
              );
            }).toList();

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: ultras.length,
              //Cuando la Página Cambie
              onPageChanged: (int page) {
                setState(() {
                  _currentPageReal = page;
                  if (page == ultras.length - 1) {
                    _currentPageFake = 2;
                  } else if (page > 0) {
                    _currentPageFake = 1;
                  } else {
                    _currentPageFake = page;
                  }
                });
              },
              
              itemBuilder: (context, index) {
                final isSelected = index == _currentPageReal;
                return UltraSelector(
                  ultra: ultras[index],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KaijuGalery(
                                ultra: ultras[index],
                              )),
                    );
                  },
                  isSelected: isSelected,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: theme.background(),
                ),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue), // Color del indicador
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
