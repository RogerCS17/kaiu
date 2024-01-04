import 'package:flutter/material.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:kaiu/src/core/models/kaiju.dart';

class KaijuGalery extends StatefulWidget {
  final String ultraName; //Nombre del Ultra
  const KaijuGalery({super.key, required this.ultraName});

  @override
  State<KaijuGalery> createState() => _KaijuGaleryState();
}

class _KaijuGaleryState extends State<KaijuGalery> {
  final theme = ThemeController.instance; //Controlador de Tema

  String searchKaiju = ""; //Cadena Escrita que Filtra el Kaiju
  List<Kaiju> selectedKaiju = []; //Todos los Kaijus Seleccionados
  List<Kaiju> filterKaijuNames =[]; //Los Kaijus resultantes posterior al filtrado

  @override
  void initState() {
    super.initState();
    selectedKaiju = ultraEnemies
        .where((element) => element.ultra == widget.ultraName)
        .toList();
    filterKaijuNames = selectedKaiju;
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
          widget.ultraName,
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
              style: TextStyle(color:theme.textPrimary()),
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
                return Center(
                  child: InkWell(
                    onTap: () {
                      // // Navegación a la pantalla de detalles del Kaiju.
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         KaijuDetailsPage(enemy: filterKaijuNames[index]),
                      //   ),
                      // );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Container(
                        // Contenedor para mostrar el Kaiju (Imagen & Detalles).
                        decoration: BoxDecoration(
                            color: filterKaijuNames[index].color,
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
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                    10), //Editar borde de imagen superior izquierdo
                                topRight: Radius.circular(
                                    10), //Editar borde de imagen superior derecho
                              ),
                              child: Container(
                                  child: Text(filterKaijuNames[index].name)),
                            ),
                            Expanded(child: Container()),
                            // Nombre del Kaiju.
                            Text(
                              filterKaijuNames[index].name,
                              style: TextStyle(
                                // Sombra para el texto - Se debe Resaltar.
                                shadows: [
                                  Shadow(
                                    color: Colors.red,
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
