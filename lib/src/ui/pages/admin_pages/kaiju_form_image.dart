import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaiu/src/core/models/kaiju.dart';
import 'package:kaiu/src/core/services/database.dart';

class KaijuFormImage extends StatefulWidget {
  const KaijuFormImage({super.key});

  @override
  KaijuFormImageState createState() => KaijuFormImageState();
}

class KaijuFormImageState extends State<KaijuFormImage> {
  final databaseMethod = DatabaseMethods.instance;

  List<Kaiju> kaijus =
      []; //La Lista de todos los Kaijus en Firebase (Inmutable)
  late Kaiju selectedKaiju; //El Kaiju particular Seleccionado

  String optionKaiju = ''; //Nombre del Kaiju a Seleccionar
  String optionUltra = ''; // Nombre del Ultra a Seleccionar - Filtro Mayor

  //Conjunto de Nombres Posibles a Seleccionar
  List<String> kaijuOptions = [];
  List<String> ultraOptions = [];

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
              img: data["img"] ?? [],
              ultra: data["ultra"] ?? "-");
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

  Future<List<String>> pickAndUploadImages(
      String ultraName, String nameKaiju) async {
    List<String> listKaijuLink = [];
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (result != null) {
        for (PlatformFile file in result.files) {
          if (['jpg', 'jpeg', 'png', 'webp'].contains(file.extension)) {
            Uint8List fileBytes = file.bytes!;

            await FirebaseStorage.instance
                .ref('Kaijus/$ultraName/$nameKaiju/${file.name}')
                .putData(
                    fileBytes, SettableMetadata(contentType: file.extension));

            String imageUrl = await FirebaseStorage.instance
                .ref('Kaijus/$ultraName/$nameKaiju/${file.name}')
                .getDownloadURL();

            listKaijuLink.add(imageUrl);

            // print('Imagen seleccionada y subida: ${file.name}');
            // print('Link Asociado: $imageUrl');
          } else {
            print('El archivo ${file.name} no es una imagen.');
            return [];
          }
        }

        //Procedemos a ordenar la Lista Correctamente
        listKaijuLink.sort((a, b) {
          // Extraer los números de los nombres de archivo
          int numA = int.parse(a.split("_")[2].split(".")[0]);
          int numB = int.parse(b.split("_")[2].split(".")[0]);

          // Comparar los números
          return numA.compareTo(numB);
        });

        //Mensaje de Aviso
        print("Lista de Imágenes Ingresadas con éxito");
        return listKaijuLink;
      } else {
        print('Selección de archivos cancelada');
        return [];
      }
    } catch (e) {
      print('Error al seleccionar los archivos: $e');
      return [];
    }
  }

  Future<void> pickAndUploadImagesGallery(
      String ultraName, String nameKaiju) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (result != null) {
        for (PlatformFile file in result.files) {
          if (['jpg', 'jpeg', 'png', 'webp'].contains(file.extension)) {
            Uint8List fileBytes = file.bytes!;

            await FirebaseStorage.instance
                .ref('GalleryImages/$nameKaiju/${file.name}')
                .putData(
                    fileBytes, SettableMetadata(contentType: file.extension));
          } else {
            print('El archivo ${file.name} no es una imagen.');
          }
        }

        //Mensaje de Aviso
        print("Lista de Imágenes de la Galería Ingresadas con éxito");
      } else {
        print('Selección de archivos cancelada');
      }
    } catch (e) {
      print('Error al seleccionar los archivos: $e');
    }
  }

  Future<String> pickAndUploadImageDrawer(
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
              .ref('KaijuDrawer/$ultraName/$nameKaiju/${file.name}')
              .putData(
                  fileBytes, SettableMetadata(contentType: file.extension));

          String imageUrl = await FirebaseStorage.instance
              .ref('KaijuDrawer/$ultraName/$nameKaiju/${file.name}')
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Imágenes'),
        actions: [],
      ),
      body: Column(
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
                      selectedKaiju = kaijus
                          .firstWhere((element) => element.name == optionKaiju);
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
                      selectedKaiju = kaijus
                          .firstWhere((element) => element.name == optionKaiju);
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
          SizedBox(height: 16), // Separador
          // Botón para subir imágenes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                var listKaijuLink = await pickAndUploadImages(
                    selectedKaiju.ultra,
                    selectedKaiju
                        .name); // De esta Forma creamos la ruta donde se guarda la Imagen
                for (var kaijuLink in listKaijuLink) {
                  selectedKaiju.img?.add(kaijuLink);
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
              child: Text('Subir Imágenes Principales'),
            ),
          ),
          // Boton Subir Imagen Drawer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                var kaijuLink = await pickAndUploadImageDrawer(
                    selectedKaiju.ultra,
                    selectedKaiju
                        .name); // De esta Forma creamos la ruta donde se guarda la Imagen

                Map<String, dynamic> updateInfo = {"imgDrawer": kaijuLink};
                await databaseMethod
                    .updateKaijuDetail(selectedKaiju.id, updateInfo)
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Imágenes Drawer Agregada",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              },
              child: Text('Subir Imagen Drawer'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await pickAndUploadImagesGallery(
                        selectedKaiju.ultra, selectedKaiju.name)
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Imágenes de la Galería Agregada",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }); // De esta Forma creamos la ruta donde se guarda la Imagen
              },
              child: Text('Subir Imagen Galería Online'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                print(await FirebaseStorage.instance
                    .ref(
                        "gs://kaiu-8295c.appspot.com/UltraImages/Logo/Ultraman_tiga_logo.png")
                    .getDownloadURL());
              },
              child: Text('Obtener Link de Imagen'),
            ),
          ),
        ],
      ),
    );
  }
}
