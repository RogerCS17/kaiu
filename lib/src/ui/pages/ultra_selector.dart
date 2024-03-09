import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/models/ultra.dart';

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
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final heightSelector = MediaQuery.of(context).size.height / 1.425;
    final widthSelector = MediaQuery.of(context).size.width / 1.5;

    return isSelected
        ? SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onPressed,
                  child: Stack(
                    children: [
                      Card(
                        margin: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10, bottom: 10),
                        elevation: 7,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: heightSelector,
                            width: widthSelector, // Altura fija del Card
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/test_image.webp',
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
                                              'assets/placeholder.webp',
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
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 0, 101, 184)
                                .withOpacity(0.85),
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
                SizedBox(
                    height: 50,
                    width: heightSelector / 5,
                    child: Image.network(
                      ultra!.imgLogo ?? "",
                    ))
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
                      'assets/placeholder.webp',
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
