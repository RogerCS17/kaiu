import 'package:flutter/material.dart';
import 'package:kaiu/src/core/models/kaiju.dart';

class KaijuHabs extends StatefulWidget {
  final Kaiju kaiju;
  const KaijuHabs({Key? key, required this.kaiju}) : super(key: key);

  @override
  State<KaijuHabs> createState() => _KaijuHabsState();
}

class _KaijuHabsState extends State<KaijuHabs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...(widget.kaiju.kaijuHabs?.keys ?? []).map((e) => Text(e)).toList(),
            ...(widget.kaiju.kaijuHabs?.values ?? []).map((e) => Text(e)).toList(),
          ],
        ),
      ),
    );
  }
}
