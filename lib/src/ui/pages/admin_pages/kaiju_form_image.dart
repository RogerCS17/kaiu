import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/services/database.dart';

class KaijuFormImage extends StatefulWidget {
  @override
  _KaijuFormImageState createState() => _KaijuFormImageState();
}

class _KaijuFormImageState extends State<KaijuFormImage> {
  //Metodo que Instancia la Base de Datos
  final databaseMethod = DatabaseMethods.instance;
  List<TextEditingController> textControllers = [TextEditingController()];

  List<Kaiju> kaijus = []; //La Lista de todos los Kaijus en Firebase
  late Kaiju selectedKaiju; //Seleccionamos un Kaiju a Actualizar
  String optionKaiju = ''; //Nombre del Kaiju a Seleccionar

  //Conjunto de Nombres Posibles de Seleccionar
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
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: // Lista desplegable al inicio
                DropdownButton<String>(
              value: optionKaiju,
              onChanged: (newValue) {
                setState(() {
                  //Seleccionamos el nombre del Kaiju
                  optionKaiju = newValue!;
                  //Obtenemos al Kaiju Individual
                  selectedKaiju = kaijus
                      .firstWhere((element) => element.name == optionKaiju);
                });
              },
              items: dropdownOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option,style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                );
              }).toList(),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            // Mostrar los campos de texto existentes
            Column(
              children: textControllers.map((controller) {
                return TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: "URL de Imagen"),
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
              onPressed: () async {
                for (var controller in textControllers) {
                  selectedKaiju.img?.add(controller.text);
                }
                Map<String, dynamic> updateInfo = {"img": selectedKaiju.img};
                await databaseMethod
                    .updateKaijuDetail(selectedKaiju.id, updateInfo)
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Imágenes Agregadas",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              },
              child: Text('Agregar Imágenes'),
            ),
          ],
        ),
      ),
    );
  }
}
