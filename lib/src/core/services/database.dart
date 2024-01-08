//Metodo de Base de Datos
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {

  // Future addEmployeeDetails(Map<String, dynamic> employeeInfoMap, String id) async {
  //   //Llamamos a una Instancia de la Base de Datos
  //   return await FirebaseFirestore.instance
  //       .collection("Employee")
  //       .doc(id)
  //       .set(employeeInfoMap);
  // }
  DatabaseMethods._();

  static final instance = DatabaseMethods._();

  // En StreamBuidler
  Stream<QuerySnapshot<Map<String, dynamic>>> getUltraDetails() {
    return FirebaseFirestore.instance.collection("Ultra").snapshots();
  }

  // En InitState -- .orderBy (Ordena de forma ascendente dado una variable de la colección)
  Future<QuerySnapshot<Map<String, dynamic>>> getKaijuDetails() async{
    return await FirebaseFirestore.instance.collection("Kaiju").orderBy("episode").get();
  }
  
  Future<String> getImageUrl(String imagePath) async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    return await ref.getDownloadURL();
  }

  // Future updateEmployeeDetail(String id, Map<String, dynamic> updateInfo) async{
  //   return await FirebaseFirestore.instance.collection("Employee").doc(id).update(updateInfo);
  // }
}
