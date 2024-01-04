import 'package:flutter/material.dart';

class Kaiju {
  //Detalles Principales
  final String name;
  final String subtitle;
  final String description;
  final List<String>? img;
  final Color color;

  //Detalles Secundarios
  final String aliasOf;
  final String height;
  final String weight;
  final String planet;
  final String ultra;
  final String comentary;
  final String imgDrawer;
  final String imgHab;

  Map<String, String>? kaijuHabs = {};

  Kaiju({
    this.name = "-",
    this.subtitle = "-",
    this.description = "-",
    this.img,
    this.kaijuHabs,
    this.color = Colors.black,
    this.aliasOf = '-',
    this.height = '-',
    this.weight = '-',
    this.planet = '-',
    this.ultra = '-',
    this.comentary = '-',
    this.imgDrawer = '-',
    this.imgHab = '-',
  });
}

final List<Kaiju> ultraEnemies = [
  Kaiju(
    name: "Bemular",
    ultra: "@Ultraman",
  ),
  Kaiju(
    name: "Alien Baltan",
    ultra: "@Ultraman",
  ),
  Kaiju(
    name: "King Joe",
    ultra: "@UltraSeven",
  ),
  Kaiju(
    name: "Bemstar",
    ultra: "@Ultraman Jack",
  ),
];
