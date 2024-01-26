import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/kaiju_galery.dart';
import 'package:kaiu/src/ui/pages/ultra_selector.dart';
import 'package:kaiu/src/ui/widget/Logo/logo.dart';

class UltraPageView extends StatefulWidget {
  const UltraPageView({super.key});

  @override
  State<UltraPageView> createState() => _UltraPageViewState();
}

class _UltraPageViewState extends State<UltraPageView> {
  final PageController _pageController = PageController(
    viewportFraction: 0.82,
  );

  int _currentPageFake = 0;
  int _currentPageReal = 0;

  final databaseMethod = DatabaseMethods.instance;
  final theme = ThemeController.instance;

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Configure.ultraRedDark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    size: 100,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          // Widget que contiene el logo de tu aplicación
          Logo(),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Selector Ultra",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.backgroundUltraRed(),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: theme.background(),
      resizeToAvoidBottomInset: false,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: databaseMethod.getUltraDetails(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<Ultra> ultras = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return Ultra(
                      name: data['name'],
                      imgPath: data["imgPath"],
                      imgLogo: data["imgLogo"],
                      imgUltra: data["imgUltra"],
                    );
                  }).toList();

                  return PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: ultras.length,
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
                              ),
                            ),
                          );
                        },
                        isSelected: isSelected,
                        currentPageFake: _currentPageFake,
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return _buildLoadingScreen();
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.transparent, // Ajusta según tu diseño
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        margin: EdgeInsets.all(2),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentPageFake == i ? Colors.blue : Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
