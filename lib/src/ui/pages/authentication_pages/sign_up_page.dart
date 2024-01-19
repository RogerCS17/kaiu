import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/services/preferences_service.dart';
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
  //Instancias de Controladores
  final theme = ThemeController.instance;
  final auth = FirebaseAuth.instance;

  //Instancia de Controladores de Texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();
  final TextEditingController _telefController = TextEditingController();

  //Variables auxiliares
  String _selectedRegionCode = '+51'; // Valor predeterminado Perú
  String _verificationId = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;

  final List<String> _regionCodes = [
    '+52', // México
    '+51', // Perú
    '+56', // Chile
    '+54', // Argentina
    '+57', // Colombia
    '+593', // Ecuador
    '+34', // España
    '+58', // Venezuela
    '+591', // Bolivia
    '+1', // Estados Unidos
    '+502', // Guatemala
    '+1', // República Dominicana
    '+55', // Brasil
    '+506', // Costa Rica
    '+595', // Paraguay
    '+503', // El Salvador
    '+505', // Nicaragua
    '+504', // Honduras
    '+507', // Panamá
    '+598', // Uruguay
    '+1', // Puerto Rico
    '+53', // Cuba
  ];

  //Funcion que devuelve un Widget - Home
  void _navigateToHome() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  //Funcion Principal del Registro
  void _signUp() async {
    setState(() {
      //Primer Cambio de Estado
      _isLoading = true; // Activa el indicador de carga
    });

    try {
      assert(_passController.text == _repassController.text,
          "Las Contraseñas no Coinciden");

      // Verificar el número de teléfono
      var phoneComplete = _selectedRegionCode + _telefController.text;

      await _verifyPhoneNumber(phoneComplete);

      // Mostrar modal para ingresar el código SMS
      await _showSmsCodeModal(phoneComplete);

      log("Registro exitoso");
    } catch (error) {
      _showErrorDialog(error.toString());
    } finally {
      setState(() {
        //Primer Cambio de Estado
        _isLoading = false; // Activa el indicador de carga
      });
    }
  }

  //Funcion que devuelve un Wdiget - Mensaje de Error
  void _showErrorDialog(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error de registro'),
            content: Text(errorMessage.toString()),
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
    });
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Manejar la verificación automática si es posible
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(
            'Error al verificar el número de teléfono: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Este callback se ejecutará cuando se haya enviado el código SMS correctamente
        // Guardar verificationId para usarlo en el siguiente paso
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Este callback se ejecutará cuando la autenticación por SMS expire
        // Puedes manejarlo según tus necesidades
      },
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> _showSmsCodeModal(String phoneNumber) async {
    String smsCode =
        ''; // Variable para almacenar el código SMS ingresado por el usuario

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese el código SMS'),
          content: TextField(
            onChanged: (value) {
              smsCode = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Verificar el código SMS ingresado por el usuario
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: _verificationId,
                    smsCode: smsCode,
                  );
                  
                  //Comprueba si las credenciales son válidas. 
                  await auth.signInWithCredential(credential);

                  await PreferencesService.instance
                      .setString("email", _emailController.text);

                  await PreferencesService.instance
                      .setString("password", _passController.text);

                  // Crear usuario después de verificar el código SMS
                  await auth.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passController.text);

                  //Iniciar Sesión después de verificar el código SMS
                  await auth.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passController.text);

                  _navigateToHome(); // Ir al Home
                } catch (e) {
                  // Manejar errores al verificar el código SMS
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error de verificación'),
                        content:
                            Text('Código SMS incorrecto. Inténtalo de nuevo.'),
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
              },
              child: Text('Verificar'),
            ),
          ],
        );
      },
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

  Widget _buildLoginForm() {
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
            padding: EdgeInsets.symmetric(horizontal: 40),
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
                SizedBox(height: 20),
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      // DropdownButton para seleccionar el código de región
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFF837E93), // Color del borde
                            width: 1, // Ancho del borde
                          ),
                        ),
                        child: DropdownButton<String>(
                          underline: Container(),
                          dropdownColor: theme.background(),
                          value: _selectedRegionCode,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRegionCode = newValue!;
                            });
                          },
                          items: _regionCodes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  value,
                                  style: TextStyle(color: theme.textPrimary()),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Espaciador
                      SizedBox(width: 8),
                      // Campo de entrada para el número de teléfono
                      Expanded(
                        child: TextField(
                          controller: _telefController,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: theme.textPrimary().withOpacity(
                                0.5), // Puedes ajustar el color según tu tema
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: theme.textPrimary(),
                            ),
                            labelText: 'Teléfono',
                            labelStyle: TextStyle(
                              color: theme.textPrimary().withOpacity(0.5),
                              fontSize: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF837E93),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF9F7BFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 17),
                SizedBox(
                  height: 56,
                  child: TextField(
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
                        Icons.lock_open,
                      ),
                      prefixIconColor: theme.textPrimary(),
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
                    obscureText: !_isRePasswordVisible,
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
                      suffixIcon: IconButton(
                        icon: Icon(
                            _isRePasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: _isRePasswordVisible
                                ? Configure.ultraRed
                                : theme.textPrimary().withOpacity(0.5)),
                        onPressed: () {
                          setState(() {
                            _isRePasswordVisible = !_isRePasswordVisible;
                          });
                        },
                      ),
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
