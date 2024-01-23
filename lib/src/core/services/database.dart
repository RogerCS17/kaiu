//Metodo de Base de Datos
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';


class DatabaseMethods {
  //Constructor Privado
  DatabaseMethods._();

  static final instance = DatabaseMethods._();

  // Implementado en StreamBuilder
  Stream<QuerySnapshot<Map<String, dynamic>>> getUltraDetails() {
    return FirebaseFirestore.instance.collection("Ultra").snapshots();
  }

  //Añadir Kaiju
  Future addKaijuDetails(Map<String, dynamic> kaijuInfoMap, String id) async {
    //Llamamos a una Instancia de la Base de Datos
    return await FirebaseFirestore.instance
        .collection("Kaiju")
        .doc(id)
        .set(kaijuInfoMap);
  }

  // Implementado en InitState
  Future<QuerySnapshot<Map<String, dynamic>>> getKaijuDetails() async {
    return await FirebaseFirestore.instance
        .collection("Kaiju")
        .orderBy("episode")
        .get();
  }

  //Funcion Actualizar Kaiju
  Future updateKaijuDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Kaiju")
        .doc(id)
        .update(updateInfo);
  }

  //Obtener URL de Imagen
  Future<String> getImageUrl(String imagePath) async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    return await ref.getDownloadURL();
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();
      print('Image uploaded. Download URL: $downloadURL');

      return downloadURL; // Devuelve la URL de descarga
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return ''; // Devuelve una cadena vacía si hay un error
    }
  }
}
