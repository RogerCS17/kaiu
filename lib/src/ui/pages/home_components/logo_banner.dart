import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/ui/configure.dart';

class LogoBanner extends StatelessWidget {
  const LogoBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchURL("https://www.youtube.com/channel/UCvx0kG1KPYrD7Ez24C2rMtQ");
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 10),
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
                color: Colors.transparent,
                child: Opacity(
                  opacity: 0.0, // Ajusta la opacidad según sea necesario
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.height/10,
                child: Image.asset("kaiu_logo.png")),
            ),
          ],
        ),
      ),
    );
  }
}
