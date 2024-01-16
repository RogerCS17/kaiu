import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/ui/pages/kaiju_galery.dart';

class UltraSelector extends StatelessWidget {
  final Ultra? ultra;
  final bool isSelected;
  final int currentPageFake;
  final Function()? onPressed;
  const UltraSelector(
      {super.key,
      this.ultra,
      required this.isSelected,
      required this.currentPageFake,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    // final theme = ThemeController.instance;
    final heightSelector = MediaQuery.of(context).size.height / 1.425;
    final theme = ThemeController.instance;

    return isSelected
        ? SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KaijuGalery(ultra: ultra!)));
                  },
                  child: Stack(
                    children: [
                      Card(
                        margin: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10, bottom: 10),
                        elevation: 7,
                        child: SizedBox(
                          height: heightSelector, // Altura fija del Card
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/test_image.png',
                                  fit: BoxFit.cover,
                                );
                              },
                              ultra?.imgPath ?? "",
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: heightSelector,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ImageFiltered(
                                          imageFilter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: Image.asset(
                                            'assets/placeholder.jpeg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                        height: heightSelector,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color:
                                            Color.fromARGB(255, 29, 182, 238),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
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
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: SizedBox(
                  height: heightSelector,
                  width: MediaQuery.of(context).size.width,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Image.asset(
                      'assets/placeholder.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  height: heightSelector,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          );
  }
}
