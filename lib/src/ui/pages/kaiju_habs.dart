import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
import 'package:kaiu/src/ui/widget/KaijuHabsPost/KaijuPost.dart';

class KaijuHabs extends StatefulWidget {
  final Kaiju kaiju;

  KaijuHabs({super.key, required this.kaiju});

  @override
  State<KaijuHabs> createState() => _KaijuHabsState();
}

class _KaijuHabsState extends State<KaijuHabs> {
  final theme = ThemeController.instance;

    bool _isConnected = true;

  // Método para verificar la conexión a Internet
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión
      setState(() {
        _isConnected = false;
      });
    } else {
      // Hay conexión
      setState(() {
        _isConnected = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected? Scaffold(
        backgroundColor: theme.background(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Habilidades",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: colorFromHex(widget.kaiju.colorHex),
        ),
        body: KaijuPostList(kaiju: widget.kaiju)):ErrorPage();
  }
}
