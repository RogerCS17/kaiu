import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/ui/widget/KaijuHabsPost/KaijuPost.dart';

class KaijuHabs extends StatelessWidget {
  final Kaiju kaiju;
  final theme = ThemeController.instance;
  KaijuHabs({super.key, required this.kaiju});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.background(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Habilidades",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: colorFromHex(kaiju.colorHex),
        ),
        body: KaijuPostList(kaiju: kaiju));
  }
}
