import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/pages/ultra_selector.dart';

class UltraPageView extends StatefulWidget {
  const UltraPageView({super.key});

  @override
  State<UltraPageView> createState() => _UltraPageViewState();
}

class _UltraPageViewState extends State<UltraPageView> {
  final PageController _pageController = PageController();
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _databaseMethods.getUltraDetails(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<Ultra> ultras = snapshot.data!.docs.map((doc) {
              // Mapear cada documento a un objeto Ultra
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Ultra(
                name: data['name'],
                imgPath: data['imgPath'],
                // Agrega otros atributos según tu modelo Ultra
              );
            }).toList();

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: ultras.length,
              itemBuilder: (context, index) {
                return UltraSelector(ultra: ultras[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}