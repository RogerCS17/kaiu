import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';

class PopularProducts extends StatelessWidget {
  PopularProducts({super.key});
  final theme = ThemeController.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Kaijus Populares", style: TextStyle(color: theme.textPrimary()), textAlign: TextAlign.left,)
        ),
      ],
    );
  }
}