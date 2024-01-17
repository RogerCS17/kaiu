import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/ui/configure.dart';

class UltraBrotherBanner extends StatelessWidget {
  const UltraBrotherBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightSelector = MediaQuery.of(context).size.height / 6;
    return GestureDetector(
      onTap: () {
        launchURL("https://www.youtube.com/channel/UCvx0kG1KPYrD7Ez24C2rMtQ");
      },
      child: Container(
        alignment: Alignment.center,
        height: heightSelector,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          // color: Configure.ultraRed,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Imagen con opacidad
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.black,
                child: Opacity(
                  opacity: 0.75, // Ajusta la opacidad según sea necesario
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/ultraman_banner.png', // Ruta de tu imagen de fondo
                      fit: BoxFit
                          .cover, // Ajusta la imagen para que cubra el contenedor
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text.rich(
                TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(text: "Visita el Canal de\n"),
                    TextSpan(
                      text: "UltraBrother M78",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
}
