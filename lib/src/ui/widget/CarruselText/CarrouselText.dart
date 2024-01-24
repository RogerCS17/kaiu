import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarrouselText extends StatefulWidget {
  final List<String> userNames;

  const CarrouselText({required this.userNames});

  @override
  _CarrouselTextState createState() => _CarrouselTextState();
}

class _CarrouselTextState extends State<CarrouselText> {
  int _currentUsuario = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.userNames
              .map(
                (usuario) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    usuario,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )
              .toList(),
          carouselController: CarouselController(),
          options: CarouselOptions(
            height: 25,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentUsuario = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
