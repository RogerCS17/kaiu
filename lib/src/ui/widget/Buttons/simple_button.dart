import 'package:flutter/material.dart';
import 'package:kaiu/src/ui/configure.dart';

class SimpleButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;

  const SimpleButton({Key? key, this.title = "", this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Configure.ultraRed),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
