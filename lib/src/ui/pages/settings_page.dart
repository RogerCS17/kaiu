import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/services/database.dart';
// import 'package:kaiu/src/ui/pages/admin_pages/admin_page_view.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/login_page.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;

  final database = DatabaseMethods.instance;

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

  bool adminConfirmation() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email == "yakomo3132@gmail.com" &&
        user?.uid == "rlBwBVg9h8RkF9kLYrwEVxpM5DF3";
  }



// Funcion Cerrar Sesión
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  // Funcion de Eliminar Cuenta
  Future<void> deleteAccount(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("¿Estás seguro de que deseas eliminar tu cuenta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma la acción
              },
              child: Text("Sí"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela la acción
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        var userId = user?.uid;

        if (user != null) {
          await user.delete();
          await database.deleteAllVotesForUser(userId ?? "");

          log('Cuenta eliminada con éxito.');
        } else {
          log('No hay usuario autenticado.');
        }
      } catch (e) {
        log('Error al eliminar la cuenta: $e');
      }
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected? Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        backgroundColor: theme.backgroundUltraRed(),
        title: Text(
          'Opciones',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Fondo de la imagen
          Image.asset(
            'assets/ultraman_background.webp',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Filtro obscuro
          Container(
            color: Colors.black.withOpacity(0.75),
            width: double.infinity,
            height: double.infinity,
          ),
          ListView(
            children: [
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(
                  'Cerrar Aplicación',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  // Cierra la aplicación
                  SystemNavigator.pop();
                },
              ),
              Divider(height: 4),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
                onTap: () => signOut(context),
              ),
              Divider(height: 4),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.white),
                title: Text(
                  'Eliminar Cuenta',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
                onTap: () => deleteAccount(context),
              ),
              // Divider(height:4),
              // adminConfirmation()
              //     ? ListTile(
              //         leading: Icon(Icons.admin_panel_settings,
              //             color: Colors.white),
              //         title: Text(
              //           'Modo Admin',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontStyle: FontStyle.italic,
              //             fontWeight: FontWeight.w300,
              //             fontSize: 15,
              //           ),
              //         ),
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => AdminPageView(),
              //             ),
              //           );
              //         },
              //       )
              //     : ListTile(),
              Divider(height: 4),
              ListTile(
                title: Text(
                  'Versión de la App: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
                subtitle: Text(
                  'Kaiu v.1.1.5',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Image.asset(
              'assets/ultra_icon.webp', // Reemplaza con la ruta de tu imagen
              width: 100, // Ajusta el tamaño según tus necesidades
              height: 100,
            ),
          ),
        ],
      ),
    ):ErrorPage();
  }
}
