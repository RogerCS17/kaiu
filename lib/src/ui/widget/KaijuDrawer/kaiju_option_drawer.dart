import 'package:flutter/material.dart';

class KaijuOptionDrawer extends StatefulWidget {
  final Color color;
  final String text;
  final Color optionColor;

  KaijuOptionDrawer({
    required this.color,
    this.text = '',
    this.optionColor = Colors.white10,
  });

  @override
  _KaijuOptionDrawerState createState() => _KaijuOptionDrawerState();
}

class _KaijuOptionDrawerState extends State<KaijuOptionDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withOpacity(0.4), // Color del borde más oscuro
                Colors.transparent, // Color transparente para el difuminado
              ],
              radius: 0.75, // Ajusta el tamaño del difuminado
            ),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value * _pulseAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5), // Color del borde difuminado
                    spreadRadius: 1, // Ajusta la extensión del difuminado
                    blurRadius: 4, // Ajusta la cantidad de difuminado
                    offset: Offset(0, 0), // Desplazamiento de la sombra
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10), // Espacio entre la viñeta y el texto
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: widget.optionColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
