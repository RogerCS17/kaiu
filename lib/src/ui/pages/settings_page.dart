import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/pages/admin_pages/admin_page_view.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/login_page.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({
    super.key,
  });

  final _auth = FirebaseAuth.instance;
  final database = DatabaseMethods.instance;
  final theme = ThemeController.instance;

  bool adminConfirmation() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email == "yakomo3132@gmail.com" || user?.uid == "rlBwBVg9h8RkF9kLYrwEVxpM5DF3";
  }

  // Funcion Cerrar Sesión
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ListView(
            children: [
              ListTile(
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: theme.textPrimary(),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300
                  ),
                ),
                onTap: () => signOut(context),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Eliminar Cuenta',
                  style: TextStyle(
                    color: theme.textPrimary(),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300
                  ),
                ),
                onTap: () => deleteAccount(context),
              ),
              Divider(),
              adminConfirmation()
                  ? ListTile(
                      title: Text(
                        'Modo Admin',
                        style: TextStyle(
                          color: theme.textPrimary(),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminPageView(),
                          ),
                        );
                      },
                    )
                  : ListTile(),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Image.asset(
              'assets/ultra_icon.png', // Reemplaza con la ruta de tu imagen
              width: 100, // Ajusta el tamaño según tus necesidades
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
