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
          style: TextStyle(color: theme.exTextPrimary()),
        ),
        backgroundColor: theme.exBackground(),
        iconTheme: IconThemeData(color: theme.exTextPrimary()),
      ),
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
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
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
