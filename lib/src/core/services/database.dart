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
  Stream<QuerySnapshot<Map<String, dynamic>>> getUltraDetails() {
    return FirebaseFirestore.instance.collection("Ultra").snapshots();
  }
  Future<String> getImageUrl(String imagePath) async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    return await ref.getDownloadURL();
  }
  // Future updateEmployeeDetail(String id, Map<String, dynamic> updateInfo) async{
  //   return await FirebaseFirestore.instance.collection("Employee").doc(id).update(updateInfo);
  // }
}
