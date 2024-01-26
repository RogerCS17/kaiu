//Metodo de Base de Datos
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<List<String>> getStorageLinkFiles(String path) async {
    List<String> filesLinks = [];

    try {
      // Accede a la ruta
      final storageRef = FirebaseStorage.instance.ref(path);

      // Lista los elementos en la ruta
      final ListResult result = await storageRef.list();

      // Itera sobre los elementos y obtiene los enlaces de descarga
      for (final Reference ref in result.items) {
        String imageUrl = await ref.getDownloadURL();
        filesLinks.add(imageUrl);
      }
    } catch (error) {
      print('Error al obtener archivos: $error');
    }

    return filesLinks;
  }

//Funcion que crea un documento para perdurar los "Favoritos"
  Future<void> likePost(String kaijuId) async {
    await FirebaseFirestore.instance
        .collection('Votes')
        .doc('${FirebaseAuth.instance.currentUser?.uid}$kaijuId')
        .set({});
  }

  //Comprobar que el voto existe
  Future<bool> hasUserLikedPost(String kaijuId) async {
    final DocumentSnapshot voteDoc = await FirebaseFirestore.instance
        .collection('Votes')
        .doc('${FirebaseAuth.instance.currentUser?.uid}$kaijuId')
        .get();

    return voteDoc.exists;
  }

  //Eliminar de "Favoritos"
  Future<void> unlikePost(String kaijuId) async {
    await FirebaseFirestore.instance
        .collection('Votes')
        .doc('${FirebaseAuth.instance.currentUser?.uid}$kaijuId')
        .delete();
  }

  //Eliminar todos los votos al eliminar la cuenta
  Future<void> deleteAllVotesForUser(String userId) async {
    try {
      final String upperBound = userId + 'z';

      final votesToDelete = await FirebaseFirestore.instance
          .collection('Votes')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: userId)
          .where(FieldPath.documentId, isLessThan: upperBound)
          .get();

      for (final doc in votesToDelete.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      print('Error al eliminar votos: $error');
    }
  }
}
