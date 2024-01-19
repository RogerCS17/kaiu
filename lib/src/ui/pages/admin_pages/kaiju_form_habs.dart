import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/services/database.dart';

class KaijuFormHabs extends StatefulWidget {
  const KaijuFormHabs({super.key});

  @override
  KaijuFormHabsState createState() => KaijuFormHabsState();
}

class KaijuFormHabsState extends State<KaijuFormHabs> {
  final databaseMethod = DatabaseMethods.instance;
  List<TextEditingController> keyControllers = [TextEditingController()];
  List<TextEditingController> valueControllers = [TextEditingController()];

  late Kaiju selectedKaiju; // Valor predeterminado
  String optionKaiju = '';
  List<Kaiju> kaijus = [];
  List<String> dropdownOptions = [];

  @override
  void initState() {
    super.initState();
    _loadKaijuData().then((kaijuList) {
      setState(() {
        //Inicializamos la Lista con todos los Kaijus
        kaijus = kaijuList;
        dropdownOptions = [...kaijuList.map((e) => e.name)];
        optionKaiju = dropdownOptions.first;
        selectedKaiju =
            kaijus.firstWhere((element) => element.name == optionKaiju);
      });
    });
  }

  Future<List<Kaiju>> _loadKaijuData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await databaseMethod.getKaijuDetails();
      if (snapshot.docs.isNotEmpty) {
        List<Kaiju> kaijuList = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return Kaiju(
              id: data["id"] ?? "-",
              name: data["name"] ?? "-",
              kaijuHabs: data["kaijuHabs"] ?? {});
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

  @override
  Widget build(BuildContext context) {
    var iterableZipController = IterableZip([keyControllers, valueControllers]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Habilidades'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              dropdownColor: Colors.black,
              value: optionKaiju,
              onChanged: (newValue) {
                setState(() {
                  optionKaiju = newValue!;
                  selectedKaiju = kaijus
                      .firstWhere((element) => element.name == optionKaiju);
                });
              },
              items: dropdownOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar los campos de texto existentes para clave y valor
            Column(
              children: iterableZipController.map((pair) {
                var keyController = pair[0];
                var valueController = pair[1];

                return Column(
                  children: [
                    TextField(
                      controller: keyController,
                      decoration:
                          InputDecoration(labelText: 'Nombre de la Habilidad'),
                    ),
                    TextField(
                      controller: valueController,
                      decoration:
                          InputDecoration(labelText: 'Imagen de la Habilidad'),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            // Botón para agregar más campos de texto para clave y valor
            ElevatedButton(
              onPressed: () {
                setState(() {
                  keyControllers.add(TextEditingController());
                  valueControllers.add(TextEditingController());
                });
              },
              child: Icon(Icons.add),
            ),
            SizedBox(height: 10),
            // Botón para imprimir los valores actuales de los campos de texto para clave y valor
            ElevatedButton(
              onPressed: () async {
                for (var pair in iterableZipController) {
                  selectedKaiju.kaijuHabs?[pair[0].text] = pair[1].text;
                  //print("Llave: ${pair[0].text}, Valor: ${pair[1].text}");
                }
                Map<String, dynamic> updateInfo = {
                  "kaijuHabs": selectedKaiju.kaijuHabs
                };
                await databaseMethod
                    .updateKaijuDetail(selectedKaiju.id, updateInfo)
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Habilidades Agregadas",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              },
              child: Text('Imprimir Valores'),
            ),
          ],
        ),
      ),
    );
  }
}
