import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/models/ultra.dart';
import 'package:kaiu/src/core/services/database.dart';
import 'package:kaiu/src/ui/pages/kaiju_details.dart';

class KaijuGalery extends StatefulWidget {
  final Ultra ultra; //Nombre del Ultra
  const KaijuGalery({super.key, required this.ultra});

  @override
  State<KaijuGalery> createState() => _KaijuGaleryState();
}

class _KaijuGaleryState extends State<KaijuGalery> {
  final theme = ThemeController.instance; //Controlador de Tema
  final databaseMethod = DatabaseMethods.instance;

  String searchKaiju = ""; //Cadena Escrita que Filtra el Kaiju
  List<Kaiju> selectedKaiju = []; //Todos los Kaijus Seleccionados
  List<Kaiju> filterKaijuNames =
      []; //Los Kaijus resultantes posterior al filtrado

  @override
  void initState() {
    super.initState();
    _loadKaijuData().then((kaijuList) {
      setState(() {
        selectedKaiju = kaijuList
            .where((element) => element.ultra == widget.ultra.name)
            .toList();
        filterKaijuNames = selectedKaiju;
      });
    });
    // selectedKaiju = ultraEnemies
    //     .where((element) => element.ultra == widget.ultraName)
    //     .toList();
    // print(selectedKaiju);
    // filterKaijuNames = selectedKaiju;
  }

  Future<List<Kaiju>> _loadKaijuData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await databaseMethod.getKaijuDetails();
      if (snapshot.docs.isNotEmpty) {
        List<Kaiju> kaijuList = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return Kaiju(
              id: data["id"],
              name: data["name"],
              subtitle: data["subtitle"] ?? "-",
              description: data["description"] ?? "-",
              img: data["img"] ??
                  [
                    "https://cdn.pixabay.com/photo/2017/01/25/17/35/picture-2008484_1280.png"
                  ],
              colorHex: data["colorHex"] ?? "-",
              aliasOf: data["aliasOf"] ?? "-",
              height: data["height"] ?? "-",
              weight: data["weight"] ?? "-",
              planet: data["planet"] ?? "-",
              ultra: data["ultra"],
              comentary: data["comentary"] ?? "-",
              imgDrawer: data["imgDrawer"] ?? "-",
              kaijuHabs: data["kaijuHabs"] ?? {"_": "_"}
              //Si no hay description en Firebase recibe -
              //description: data["description"]
              );
        }).toList();

        return kaijuList;
      } else {
        // Si no hay documentos, devuelve una lista vacía
        return [];
      }
    } catch (error) {
      print('Error al cargar datos: $error');
      // Puedes manejar el error según tus necesidades, y aquí también puedes devolver una lista vacía o null
      return [];
    }
  }

  void _filterContainers(String query) {
    setState(() {
      // Actualización del filtro y las listas.
      searchKaiju = query;
      // selectedKaiju = ultraEnemies
      //     .where((element) => element.ultra == widget.ultraName)
      //     .toList();
      filterKaijuNames = selectedKaiju
          .where(
              (enemy) => enemy.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        backgroundColor: theme.background(),
        title: Text(
          widget.ultra.name!,
          style: TextStyle(color: theme.textPrimary()),
        ),
        iconTheme: IconThemeData(
          color: theme.textPrimary(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: theme.textPrimary()),
              onChanged: _filterContainers,
              decoration: InputDecoration(
                labelText: "Buscar Kaiju",
                labelStyle: TextStyle(color: theme.textPrimary()),
                prefixIcon: Icon(Icons.search),
                prefixIconColor: theme.textPrimary(),
                suffixIconColor: theme.textPrimary().withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 2,
              ),
              itemCount: filterKaijuNames.length,
              itemBuilder: (context, index) {
                final imageIndex = generateRandomNumberOneToNine();
                return Center(
                  child: InkWell(
                    onTap: () {
                      // // Navegación a la pantalla de detalles del Kaiju.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KaijuDetails(
                            kaiju: filterKaijuNames[index],
                            ultra: widget.ultra,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Container(
                        // Contenedor para mostrar el Kaiju (Imagen & Detalles).
                        decoration: BoxDecoration(
                            color:
                                colorFromHex(filterKaijuNames[index].colorHex),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 2.25,
                                offset: Offset(0, 4),
                              )
                            ]),
                        child: Column(
                          children: [
                            // Imagen del Kaiju.
                            Container(
                              decoration:
                                  BoxDecoration(color: theme.background()),
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.height / 2,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                      10), //Editar borde de imagen superior izquierdo
                                  topRight: Radius.circular(
                                      10), //Editar borde de imagen superior derecho
                                ),
                                child: Image.network(
                                  filterKaijuNames[index].img![0],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      // Muestra el indicador de carga mientras la imagen se está cargando
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
                                                fit: BoxFit.cover,
                                                "assets/kaiju_placeholder ($imageIndex).webp"),
                                          ),
                                          CircularProgressIndicator(
                                            strokeWidth: 4,
                                            color: Color.fromARGB(
                                                255, 29, 182, 238),
                                          )
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            // Nombre del Kaiju.
                            Text(
                              filterKaijuNames[index].name,
                              style: TextStyle(
                                // Sombra para el texto - Se debe Resaltar.
                                shadows: const [
                                  Shadow(
                                    color: Color.fromARGB(255, 81, 81, 81),
                                    offset: Offset(0, 0),
                                    blurRadius: 10,
                                  )
                                ],
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //Espaciado
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
