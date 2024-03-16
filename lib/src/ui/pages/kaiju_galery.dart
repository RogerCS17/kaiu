import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/configure.dart';
import 'package:kaiu/src/ui/pages/error_page.dart';
import 'package:kaiu/src/ui/pages/kaiju_details.dart';

class KaijuGalery extends StatefulWidget {
  final Ultra ultra; //Nombre del Ultra
  const KaijuGalery({super.key, required this.ultra});

  @override
  State<KaijuGalery> createState() => _KaijuGaleryState();
}

class _KaijuGaleryState extends State<KaijuGalery> {
  final theme = ThemeController.instance; //Controlador de Tema
  final database = DatabaseMethods.instance;
  late Future<List<Kaiju>>
      _kaijuListFuture; // Future que contendrá la lista de Kaijus

  String searchKaiju = ""; //Cadena Escrita que Filtra el Kaiju

  bool _isConnected = true;

  // Método para verificar la conexión a Internet
  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión
      setState(() {
        _isConnected = false;
      });
    } else {
      // Hay conexión
      setState(() {
        _isConnected = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection().then((value) {
      _kaijuListFuture = _loadKaijuData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? Scaffold(
            appBar: AppBar(
              actions: [
                Builder(
                  // Usamos Builder para obtener un contexto dentro del Scaffold
                  builder: (context) => IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Abre el Drawer
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ],
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: theme.backgroundUltraRed(),
              title: Text(
                widget.ultra.name!,
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),

            //COMENTAR
            drawer: Drawer(
              width: MediaQuery.of(context).size.width,
              backgroundColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (query) {
                        setState(() {
                          searchKaiju = query;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Buscar Kaiju",
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.search), // Icono de búsqueda
                        prefixIconColor: Colors.white,
                        suffixIconColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Configure.ultraRedBackground,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Aceptar"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Configure.ultraRedBackground,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                searchKaiju = "";
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Ver todos"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            //COMENTAR
            backgroundColor: theme.background(),
            body: FutureBuilder<List<Kaiju>>(
              future: _kaijuListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Muestra un círculo de carga mientras se obtienen los datos
                  return Center(
                    child: SpinKitCubeGrid(
                      size: 100,
                      color: ThemeController.instance.exBackground(),
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                } else if (snapshot.hasError) {
                  // Muestra un mensaje de error si ocurrió algún problema al obtener los datos
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // Muestra la lista de Kaijus una vez que se hayan obtenido los datos
                  final kaijuList = snapshot.data!;
                  return _buildKaijuGrid(kaijuList);
                }
              },
            ),
          )
        : ErrorPage();
  }

  Widget _buildKaijuGrid(List<Kaiju> kaijuList) {
    // Filtra la lista de Kaijus en función del término de búsqueda
    final filteredKaijuList = kaijuList
        .where((kaiju) =>
            kaiju.name.toLowerCase().contains(searchKaiju.toLowerCase()))
        .toList();

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 2,
            ),
            itemCount: filteredKaijuList.length,
            itemBuilder: (context, index) {
              final kaiju = filteredKaijuList[index];
              final imageIndex = generateRandomNumberOneToNine();
              return Center(
                child: InkWell(
                  splashFactory: InkSparkle.splashFactory,
                  splashColor: Colors.blue,
                  onTap: () async {
                    Future.delayed(Duration(milliseconds: 250), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KaijuDetails(
                            kaiju: kaiju,
                            ultra: widget.ultra,
                          ),
                        ),
                      );
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(9.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorFromHex(kaiju.colorHex),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 2.25,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration:
                                BoxDecoration(color: theme.background()),
                            height: MediaQuery.of(context).size.height / 6,
                            width: MediaQuery.of(context).size.height / 2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(
                                kaiju.img!.first,
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              6,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          child: Image.asset(
                                            "assets/kaiju_placeholder ($imageIndex).webp",
                                            fit: BoxFit.cover,
                                          ),
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
                          Expanded(child: Container()),
                          Text(
                            kaiju.name,
                            style: TextStyle(
                              shadows: const [
                                Shadow(
                                  color: Color.fromARGB(255, 81, 81, 81),
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                ),
                              ],
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<List<Kaiju>> _loadKaijuData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await database.getKaijuDetails(widget.ultra.name!);
      if (snapshot.docs.isNotEmpty) {
        List<Kaiju> kaijuList = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return Kaiju(
            id: data["id"] ?? "-",
            name: data["name"] ?? "-",
            img: data["img"] ?? [],
            ultra: data["ultra"] ?? "-",
            colorHex: data["colorHex"] ?? "#bf0705",
            subtitle: data["subtitle"] ?? "-",
            description: data["description"] ?? "-",
            aliasOf: data["aliasOf"] ?? "-",
            height: data["height"] ?? "-",
            weight: data["weight"] ?? "-",
            planet: data["planet"] ?? "-",
            comentary: data["comentary"] ?? "-",
            imgDrawer: data["imgDrawer"] ?? "-",
            kaijuHabs: data["kaijuHabs"] ?? {},
            usersPremium: data["usersPremium"] ?? [],
            yLink: data["yLink"] ?? "-",
            shortLink: data["shortLink"] ?? "-",
            vote: data["vote"] ?? 0,
            episode: data["episode"] ?? 0,
          );
        }).toList();
        //Ordenamiento por Código - Reemplaza a Firebase
        kaijuList.sort((a, b) {
          int episodeComparison = a.episode.compareTo(b.episode);
          if (episodeComparison != 0) {
            // Si los episodios son diferentes, devuelve la comparación de episodios
            return episodeComparison;
          } else {
            // Si los episodios son iguales, ordena por nombre en orden ascendente
            return a.name.compareTo(b.name);
          }
        });
        return kaijuList;
      } else {
        return [];
      }
    } catch (error) {
      // print('Error al cargar datos: $error');
      return [];
    }
  }
}
