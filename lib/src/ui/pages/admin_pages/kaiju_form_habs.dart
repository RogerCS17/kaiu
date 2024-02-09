import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  // List<TextEditingController> keyControllers = [TextEditingController()];
  // List<TextEditingController> valueControllers = [TextEditingController()];

  List<TextEditingController> descriptionControllers = [
    TextEditingController()
  ];
  List<TextEditingController> nameControllers = [TextEditingController()];
  List<TextEditingController> timeAgoControllers = [TextEditingController()];
  List<TextEditingController> linkImageControllers = [TextEditingController()];

  late int keyCount; //Contador que funciona como llave principal
  List<Kaiju> kaijus = [];
  late Kaiju selectedKaiju;
  String optionKaiju = '';
  String optionUltra = '';

  List<String> kaijuOptions = [];
  List<String> ultraOptions = [];

  Future<String> pickAndUploadImageHabs(
      String ultraName, String nameKaiju) async {
    String kaijuLink = "";
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (result != null) {
        var file = result.files.first;
        if (['jpg', 'jpeg', 'png', 'webp'].contains(file.extension)) {
          Uint8List fileBytes = file.bytes!;

          await FirebaseStorage.instance
              .ref('KaijuHabs/$ultraName/$nameKaiju/${file.name}')
              .putData(
                  fileBytes, SettableMetadata(contentType: file.extension));

          String imageUrl = await FirebaseStorage.instance
              .ref('KaijuHabs/$ultraName/$nameKaiju/${file.name}')
              .getDownloadURL();
          kaijuLink = imageUrl;

          // print('Imagen seleccionada y subida: ${file.name}');
          // print('Link Asociado: $imageUrl');
        } else {
          print('El archivo ${file.name} no es una imagen.');
          return "";
        }

        //Mensaje de Aviso
        print("Lista de Imágenes Ingresadas con éxito");
        return kaijuLink;
      } else {
        print('Selección de archivos cancelada');
        return "";
      }
    } catch (e) {
      print('Error al seleccionar los archivos: $e');
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _loadKaijuData().then((kaijuList) {
      setState(() {
        // Inicializamos la Lista con todos los Kaijus
        kaijus = kaijuList;

        // Inicializamos la Lista de Ultra con nombres únicos
        ultraOptions = kaijuList.map((e) => e.ultra).toSet().toList();
        ultraOptions.sort();

        // Establecemos las opciones de Ultra y la opción por defecto
        kaijuOptions = [...kaijuList.map((e) => e.name)];
        optionKaiju = kaijuOptions.first;
        optionUltra = ultraOptions.first;

        // Establecemos el Kaiju y Ultra seleccionados
        selectedKaiju =
            kaijus.firstWhere((element) => element.name == optionKaiju);

        //Comprobar el largo
        keyCount = selectedKaiju.kaijuHabs?.length ?? 0;
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
              ultra: data["ultra"] ?? "-",
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
    var iterableZipController = IterableZip([
      nameControllers,
      descriptionControllers,
      timeAgoControllers,
      linkImageControllers
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Habilidades'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Filtro Kaiju",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Dropdown para seleccionar "Ultra"
                  Expanded(
                    child: DropdownButton<String>(
                      value: optionUltra,
                      onChanged: (newValue) {
                        setState(() {
                          optionUltra = newValue!;
                          kaijuOptions = kaijus
                              .where((element) => element.ultra == optionUltra)
                              .map((e) => e.name)
                              .toList();
                          optionKaiju = kaijuOptions.first;
                          selectedKaiju = kaijus.firstWhere(
                              (element) => element.name == optionKaiju);
                          keyCount = selectedKaiju.kaijuHabs?.length ?? 0;
                        });
                      },
                      items: ultraOptions.map((ultraOption) {
                        return DropdownMenuItem<String>(
                          value: ultraOption,
                          child: Text(
                            ultraOption,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 209, 6, 6),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 16), // Separador
                  // Dropdown para seleccionar "Kaiju"
                  Expanded(
                    child: DropdownButton<String>(
                      value: optionKaiju,
                      onChanged: (newValue) {
                        setState(() {
                          optionKaiju = newValue!;
                          selectedKaiju = kaijus.firstWhere(
                              (element) => element.name == optionKaiju);
                          keyCount = selectedKaiju.kaijuHabs?.length ?? 0;
                        });
                      },
                      items: kaijuOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: TextStyle(
                                color: Color.fromARGB(255, 5, 29, 245),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              // Mostrar los campos de texto existentes para clave y valor
              Column(
                children: iterableZipController.map((tetra) {
                  var nameController = tetra[0];
                  var descriptionController = tetra[1];
                  var timeAgoController = tetra[2];
                  var linkImageController = tetra[3];
        
                  return Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration:
                            InputDecoration(labelText: 'Nombre de la Habilidad'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            InputDecoration(labelText: 'Ingrese la Descripción'),
                      ),
                      TextField(
                        controller: timeAgoController,
                        decoration:
                            InputDecoration(labelText: 'Ingrese la Fecha'),
                      ),
                      TextField(
                        enabled: false,
                        controller: linkImageController,
                        decoration: InputDecoration(labelText: 'Ingrese el Link'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              var url = await pickAndUploadImageHabs(
                                  selectedKaiju.ultra, selectedKaiju.name);
                              setState(() {
                                linkImageController.text = url;
                              });
                            },
                            child: Text("Subir Imagen")),
                      )
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              // Botón para agregar más campos de texto para clave y valor
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    nameControllers.add(TextEditingController());
                    descriptionControllers.add(TextEditingController());
                    timeAgoControllers.add(TextEditingController());
                    linkImageControllers.add(TextEditingController());
                  });
                },
                child: Icon(Icons.add),
              ),
              SizedBox(height: 10),
              // Botón para imprimir los valores actuales de los campos de texto para clave y valor
              ElevatedButton(
                onPressed: () async {
                  //Poblar Diccionario
                  for (var tetra in iterableZipController) {
                    selectedKaiju.kaijuHabs!["$keyCount"] = {
                      "name": tetra[0].text,
                      "description": tetra[1].text,
                      "timeAgo": tetra[2].text,
                      "image": tetra[3].text
                    };
        
                    keyCount++; // Incrementar keyCount después de cada iteración
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
                child: Text('Agregar Habilidades'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
