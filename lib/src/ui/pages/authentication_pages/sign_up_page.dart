import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/login_page.dart';
import 'package:kaiu/src/ui/pages/home.dart';
import 'package:kaiu/src/ui/widget/Logo/logo.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final theme = ThemeController.instance;
  final auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();

  void _signUp() async {
    log("Funciona");
    String email = _emailController.text;
    String password = _passController.text;
    String rePassword = _repassController.text;
    try {
      assert(password == rePassword, "Las Contraseñas no Coinciden");
      final response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
          log("Registro exitoso");
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Home()));
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de registro'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightSelector = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      backgroundColor: theme.background(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  75.0), // Ajusta el radio según tus necesidades
              child: Image.asset(
                "assets/ultra_sign_up.png",
                height: heightSelector,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Regístrate en",
                      style:
                          TextStyle(fontSize: 30, color: theme.textPrimary()),
                    ),
                    Logo(),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 56,
                  child: TextField(
                    controller: _emailController,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: theme.textPrimary(),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      prefixIconColor: theme.textPrimary(),
                      labelText: 'Correo',
                      labelStyle: TextStyle(
                        color: theme.textPrimary().withOpacity(0.5),
                        fontSize: 15,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9F7BFF),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 17),
                SizedBox(
                  height: 56,
                  child: TextField(
                    controller: _passController,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: theme.textPrimary(),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_open),
                      prefixIconColor: theme.textPrimary(),
                      labelText: 'Contraseña',
                      // hintText: 'Crear Contraseña',
                      hintStyle: TextStyle(
                        color: Color(0xFF837E93),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: TextStyle(
                        color: theme.textPrimary().withOpacity(0.5),
                        fontSize: 15,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9F7BFF),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 17),
                SizedBox(
                  height: 56,
                  child: TextField(
                    controller: _repassController,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: theme.textPrimary(),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      prefixIconColor: theme.textPrimary(),
                      labelText: 'Confirmar Contraseña',
                      // hintText: 'Confirmando',
                      hintStyle: TextStyle(
                        color: Color(0xFF837E93),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: TextStyle(
                        color: theme.textPrimary().withOpacity(0.5),
                        fontSize: 15,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9F7BFF),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: ElevatedButton(
                    onPressed: () {
                      _signUp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Configure.ultraRed,
                    ),
                    child: const Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tenías una Cuenta? ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF837E93),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 2.5),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Inicia Sesión',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blueAccent,
                          color: Colors.blueAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
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