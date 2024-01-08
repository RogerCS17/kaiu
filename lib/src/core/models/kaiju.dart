class Kaiju {
  //Detalles Principales
  final String name;
  final String subtitle;
  final String description;
  final List<dynamic>? img;
  final String colorHex; // Falta

  //Detalles Secundarios
  final String aliasOf;
  final String height;
  final String weight;
  final String planet;
  final String ultra;
  final String comentary;
  final String imgDrawer;
  final String imgHab;

  //Atributo para Ordenar
  final int episode; 

  Map<String, String>? kaijuHabs = {};

  Kaiju({
    this.name = "-",
    this.subtitle = "-",
    this.description = "-",
    this.img,
    this.kaijuHabs,
    this.colorHex = "-",
    this.aliasOf = '-',
    this.height = '-',
    this.weight = '-',
    this.planet = '-',
    this.ultra = '-',
    this.comentary = '-',
    this.imgDrawer = '-',
    this.imgHab = '-',
    this.episode = 0,
  });
}
