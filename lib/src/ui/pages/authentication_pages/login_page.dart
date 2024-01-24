import 'package:flutter/material.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/reset_password_page.dart';
import 'package:kaiu/src/ui/pages/authentication_pages/sign_up_page.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/services/preferences_service.dart';
import 'package:kaiu/src/ui/widget/Logo/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controladores
  final theme = ThemeController.instance;
  final auth = FirebaseAuth.instance;

  //Controladores de Texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  //Variables Empleadas
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEmailPassword().then((list) {
      _emailController.text = list[0]; // 0 -> Correo
      _passController.text = list[1]; //1 -> Contraseña
    });
  }

  //Cargando las Preferencias de Correo & Contraseña
  Future<List<String>> _loadEmailPassword() async {
    final email = await PreferencesService.instance.getString("email");
    final password = await PreferencesService.instance.getString("password");
    return [email, password];
  }

  //Función Principal de Logueo
  void _login() async {
    setState(() {
      _isLoading = true; // Activa el indicador de carga
    });

    try {
      //Iniciar Sesión en Firebase
      await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passController.text);
      //Setear Preferencias
      await PreferencesService.instance
          .setString("email", _emailController.text);
      await PreferencesService.instance
          .setString("password", _passController.text);
      //Redirige al Home
      _navigateToHome();
    } catch (error) {
      _showErrorDialog(
          error.toString()); // Mostrar Error en Caso de no Iniciar Sesión.
    } finally {
      setState(() {
        _isLoading =
            false; // Desactiva el indicador de carga una vez que termine
      });
    }
  }

  //Funcion que nos redirige al Home.
  void _navigateToHome() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  //Dialogo que presenta el Error al Iniciar Sesión
  void _showErrorDialog(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Continuar'),
              ),
            ],
          );
        },
      );
    });
  }

  //Formulario de Login
  Widget _buildLoginForm() {
    final heightSelector = MediaQuery.of(context).size.height / 2.5;
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Padding(
          padding: const EdgeInsets.all(0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.asset(
              "assets/ultra_login.png",
              height: heightSelector,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Bienvenido a",
                    style: TextStyle(fontSize: 30, color: theme.textPrimary()),
                  ),
                  Logo(),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: theme.textPrimary(),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(
                      0), // Ajusta el relleno según tus necesidades
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  prefixIcon: Icon(Icons.email, color: theme.textPrimary()),
                  labelText: 'Correo',
                  labelStyle: TextStyle(
                    color: theme.textPrimary().withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
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
              const SizedBox(height: 15),
              TextField(
                obscureText: !_isPasswordVisible,
                controller: _passController,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: theme.textPrimary(),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: theme.textPrimary(),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: _isPasswordVisible
                            ? Configure.ultraRed
                            : theme.textPrimary().withOpacity(0.5)),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    color: theme.textPrimary().withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Configure.ultraRed,
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes una Cuenta? ',
                    style: TextStyle(
                      color: Color(0xFF837E93),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2.5),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                        color: theme.textPrimary(),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Acción a realizar cuando se presiona el botón de texto
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '¿Olvidaste tu Contraseña?',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blueAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Funcion que devuelve un Widget - Pantalla de Carga
  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.blueAccent,
      ),
    );
  }

  //Widget Principal
  @override
  Widget build(BuildContext context) {
    //Widget Principal
    return Scaffold(
      backgroundColor: theme.background(),
      body: _isLoading
          ? _buildLoadingScreen()
          : _buildLoginForm(), // Mostrar el formulario o pantalla de carga
    );
  }
}
