class Kaiju {
  
  //Atributo para Firebase 
  final String id; 
  
  //Detalles Principales
  final String name;
  final String subtitle;
  final String description;
  final List<dynamic>? img;
  final String colorHex;

  //Detalles Secundarios
  final String aliasOf;
  final String height;
  final String weight;
  final String planet;
  final String ultra;
  final String comentary;
  final String imgDrawer;
  
  Map<String, dynamic>? kaijuHabs = {};
  
  //final String imgHab;

  //Atributo para Ordenar
  final int episode; 


  Kaiju({
    this.id = "-",
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
    //this.imgHab = '-',
    this.episode = 0,
  });
}
