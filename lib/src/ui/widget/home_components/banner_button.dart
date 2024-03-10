import 'package:flutter/material.dart';

class BannerButton extends StatefulWidget {
  final Function()? onTap;
  final String image;
  final String primaryMessage;
  final String secondaryMessage;

  const BannerButton({
    required this.onTap,
    required this.primaryMessage,
    required this.secondaryMessage,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  _BannerButtonState createState() => _BannerButtonState();
}

class _BannerButtonState extends State<BannerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: 2500), // Ajusta la duración según sea necesario
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Iniciar la animación cuando el widget se inicia
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final heightSelector = MediaQuery.of(context).size.height / 6;
    final widthSelector = MediaQuery.of(context).size.width / 1.1;

    return InkWell(
      splashColor: Colors.blue,
      splashFactory: InkRipple.splashFactory,
      onTap: () {
        // Ejecuta la función onTap y luego espera 500 milisegundos antes de cambiar de página
        Future.delayed(Duration(milliseconds: 550), () {
          widget.onTap?.call();
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Fondo con opacidad animada
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: heightSelector,
                    width: widthSelector,
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${widget.primaryMessage}\n",
                      style: TextStyle(
                        color: Colors.white,
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(3, 1),
                            blurRadius: 6.0,
                            color: Color.fromARGB(255, 231, 42, 9),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: widget.secondaryMessage,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(3, 1),
                            blurRadius: 5.0,
                            color: Color.fromARGB(255, 0, 25, 136),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.touch_app_outlined,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
