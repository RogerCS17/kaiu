import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/services/preferences_service.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/widget/Logo/logo.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final theme = ThemeController.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEmail().then((email) {
      _emailController.text = email; // 0 > Correo
    });
  }

  Future<String> _loadEmail() async {
    final email = await PreferencesService.instance.getString("email");
    return email;
  }

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var methods =
          await _auth.fetchSignInMethodsForEmail(_emailController.text);
      assert(methods.isNotEmpty, "El Correo no se encuentra Registrado");
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      _showResetPasswordSuccessDialog();
    } catch (error) {
      _showErrorDialog(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showResetPasswordSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restablecimiento de Contraseña'),
          content: Text(
              'Se ha enviado un correo electrónico con instrucciones para restablecer tu contraseña.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // Cerrar la página de restablecimiento de contraseña
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de Restablecimiento de Contraseña'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        title: Text(
          "Regresar",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Configure.ultraRed,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading ? _buildLoadingScreen() : _buildResetPasswordForm(),
    );
  }

  Widget _buildResetPasswordForm() {
    final heightSelector = MediaQuery.of(context).size.height / 2.5;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                "Restablece tu Contraseña",
                style: TextStyle(color: theme.textPrimary(), fontSize: 20),
              ),
              Logo(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.asset(
                    "assets/ultra_reset.png",
                    height: heightSelector,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: TextField(
                  controller: _emailController,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: theme.textPrimary(),
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: theme.textPrimary(),
                    ),
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
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  _resetPassword();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Configure.ultraRed,
                ),
                child: Text(
                  'Enviar Solicitud',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.blueAccent,
      ),
    );
  }
}
