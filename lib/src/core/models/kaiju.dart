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

  //Variables que se usaran en un futuro
  //final int numOfVotes;
  
  Map<String, dynamic>? kaijuHabs = {};
  

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
    this.episode = 0,
  });
}
