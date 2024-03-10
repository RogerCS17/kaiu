import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
import 'package:kaiu/src/ui/pages/settings_page.dart';
import 'package:kaiu/src/ui/widget/PermissionStatus/PermissionStatusWidget.dart';
import 'package:kaiu/src/ui/widget/ThreadsWidget/threads_widget.dart';
import 'package:kaiu/src/ui/widget/home_components/banner_button.dart';
import 'package:kaiu/src/ui/pages/ultra_page_view.dart';
// import 'package:kaiu/src/ui/widget/home_components/youtuber_player_screen.dart';

class Home extends StatefulWidget {
  Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final theme = ThemeController.instance;
  final database = DatabaseMethods.instance;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

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
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: theme.brightness,
      builder: (BuildContext context, value, child) {
        return _isConnected
            ? Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    "Página Inicio",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: theme.backgroundUltraRed(),
                  actions: [
                    PermissionStatusWidget(),
                    IconButton(
                      icon: Icon(
                        theme.brightnessValue
                            ? Icons.light_mode
                            : Icons.brightness_medium,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        theme.changeTheme();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                backgroundColor: theme.background(),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BannerButton(
                          primaryMessage: "Visita el Canal de",
                          secondaryMessage: "UltraBrother M78",
                          onTap: () {
                            applaunchUrl(
                                "https://www.youtube.com/channel/UCvx0kG1KPYrD7Ez24C2rMtQ");
                          },
                          image: "assets/ultraman_banner.webp",
                        ),
                        BannerButton(
                          primaryMessage: "Visita la Novedosa",
                          secondaryMessage: "Galería Kaiju",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UltraPageView(),
                              ),
                            );
                          },
                          image: "assets/kaiju_banner.webp",
                        ),
                        BannerButton(
                          primaryMessage: "Visita el TikTok de",
                          secondaryMessage: "UltraBrother M78",
                          onTap: () {
                            applaunchUrl(
                                "https://www.tiktok.com/@ultrabrother_m78");
                          },
                          image: "assets/tiktok_banner.webp",
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ThreadsWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ErrorPage();
      },
    );
  }
}
