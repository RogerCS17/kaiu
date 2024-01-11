import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/services/database.dart';

class KaijuFormImage extends StatefulWidget {
  @override
  _KaijuFormImageState createState() => _KaijuFormImageState();
}

class _KaijuFormImageState extends State<KaijuFormImage> {
  //Controlador de Base de Datos
  final databaseMethod = DatabaseMethods.instance;
  //Controlador de Textos
  List<TextEditingController> textControllers = [TextEditingController()];
  //Lista de todos los Kaijus en Firebase
  List<Kaiju> kaijus = [];
  //Modelo Individual a Actualizar
  late Kaiju selectedKaiju;
  //Nombre a Seleccionar
  String optionKaiju = '';

  //Conjunto de Nombres Posibles de Seleccionar
  List<String> dropdownOptions = [];

  @override
  void initState() {
    super.initState();
    _loadKaijuData().then((kaijuList) {
      setState(() {
        //Inicializamos la Lista con todos los Kaijus
        kaijus = kaijuList;
        //Todos los Nombres de los Kaijus Disponibles
        dropdownOptions = [
          ...kaijuList.map((e) => e.name)
        ]; // → ["Bemular", "askjsfa", "sdofihsafo"]
        optionKaiju = dropdownOptions.first; // "Bemular"
        //Inicializando el Filtro.
        selectedKaiju =
            kaijus.where((element) => element.name == optionKaiju).first;
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
              name: data["name"],
              img: data["img"] ??
                  [
                    "https://cdn.pixabay.com/photo/2017/01/25/17/35/picture-2008484_1280.png"
                  ]);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Kaiju Form Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista desplegable al inicio
            Align(
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                value: optionKaiju,
                onChanged: (newValue) {
                  setState(() {
                    //Seleccionamos el nombre del Kaiju
                    optionKaiju = newValue!;
                    //Obtenemos al Kaiju Individual
                    selectedKaiju = kaijus
                        .where((element) => element.name == optionKaiju)
                        .first;
                  });
                },
                items: dropdownOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
            // Mostrar los campos de texto existentes
            Column(
              children: textControllers.map((controller) {
                return TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Campo de Texto'),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            // Botón para agregar más campos de texto
            ElevatedButton(
              onPressed: () {
                setState(() {
                  textControllers.add(TextEditingController());
                });
              },
              child: Icon(Icons.add),
            ),
            SizedBox(height: 10),
            // Botón para imprimir los valores actuales de los campos de texto
            ElevatedButton(
              onPressed: () {
                for (var controller in textControllers) {
                  selectedKaiju.img?.add(controller.text);
                }
                Map<String, dynamic> updateInfo = {"img": selectedKaiju.img};
                databaseMethod.updateKaijuDetail("0su20Y031w", updateInfo);
              },
              child: Text('Imprimir Valores'),
            ),
          ],
        ),
      ),
    );
  }
}
