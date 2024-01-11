//Metodo de Base de Datos
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  
  //Constructor Privado
  DatabaseMethods._();

  static final instance = DatabaseMethods._();

  //Añadir Kaiju
  Future addKaijuDetails(Map<String, dynamic> kaijuInfoMap, String id) async {
    //Llamamos a una Instancia de la Base de Datos
    return await FirebaseFirestore.instance
        .collection("Kaiju")
        .doc(id)
        .set(kaijuInfoMap);
  }

  // En StreamBuidler
  Stream<QuerySnapshot<Map<String, dynamic>>> getUltraDetails() {
    return FirebaseFirestore.instance.collection("Ultra").snapshots();
  }

  // En InitState -- .orderBy (Ordena de forma ascendente dado una variable de la colección)
  Future<QuerySnapshot<Map<String, dynamic>>> getKaijuDetails() async{
    return await FirebaseFirestore.instance.collection("Kaiju").orderBy("episode").get();
  }
  
  //Obtener URL de Imagen
  Future<String> getImageUrl(String imagePath) async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    return await ref.getDownloadURL();
  }

  Future updateKaijuDetail(String id, Map<String, dynamic> updateInfo) async{
    return await FirebaseFirestore.instance.collection("Kaiju").doc(id).update(updateInfo);
  }
}
