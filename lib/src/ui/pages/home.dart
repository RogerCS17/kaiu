import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/ui/pages/admin_pages/admin_page_view.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/login_page.dart';
import 'package:kaiu/src/ui/widget/home_components/banner_button.dart';
import 'package:kaiu/src/ui/pages/ultra_page_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  static String routeName = "/home";
  final theme = ThemeController.instance;
  final _auth = FirebaseAuth.instance;

  Home({super.key});

  void signOut() async {
    await _auth.signOut();
  }

  void deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
        print('Cuenta eliminada con éxito.');
      } else {
        print('No hay usuario autenticado.');
      }
    } catch (e) {
      print('Error al eliminar la cuenta: $e');
    }
  }

  Future<void> _launchUrl(String url) async {
    var _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: theme.brightness,
        builder: (BuildContext context, value, child) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "Página Inicio",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: theme.backgroundUltraRed(),
              actions: [
                PopupMenuButton<String>(
                  color: Colors.white.withOpacity(0.9),
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onSelected: (value) {
                    // Acción a realizar cuando se selecciona una opción
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        child: theme.brightnessValue
                            ? Text("Modo Obscuro")
                            : Text('Modo Claro'),
                        onTap: () {
                          theme.changeTheme();
                        },
                      ),
                      PopupMenuItem<String>(
                        value: 'opcion2',
                        child: Text('Cerrar Sesión'),
                        onTap: () async {
                          signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                      ),
                      PopupMenuItem<String>(
                        value: 'opcion3',
                        child: Text('Modo Admin'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminPageView()));
                        },
                      ),
                      PopupMenuItem<String>(
                        value: 'opcion4',
                        child: Text('Borrar cuenta'),
                        onTap: () async {
                          deleteAccount();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                      ),
                    ];
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
                    //Para Rediriginar al Canal de Youtube
                    BannerButton(
                        primaryMessage: "Visita el Canal de",
                        secondaryMessage: "UltraBrother M78",
                        onTap: () {
                          _launchUrl(
                              "https://www.youtube.com/channel/UCvx0kG1KPYrD7Ez24C2rMtQ");
                        },
                        image: "assets/ultraman_banner.png"),

                    //Para Acceder a la Galería Kaiju
                    BannerButton(
                        primaryMessage: "Visita la Novedosa",
                        secondaryMessage: "Galería Kaiju",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UltraPageView()));
                        },
                        image: "assets/kaiju_banner.png"),

                    BannerButton(
                        primaryMessage: "Visita el TikTok de",
                        secondaryMessage: "UltraBrother M78",
                        onTap: () {
                          _launchUrl("https://www.tiktok.com/@ultrabrother_m78");
                        },
                        image: "assets/tiktok_banner.jpeg"),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
