import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatelessWidget {
  final String documentId;

  YoutubePlayerScreen({Key? key, required this.documentId}) : super(key: key);

  Future<String> getVideoId(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Video')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        return documentSnapshot.get('id_video');
      } else {
        return ""; // Puedes manejar este caso de acuerdo a tus necesidades
      }
    } catch (e) {
      print('Error al obtener el ID del video: $e');
      throw e; // Propagar el error para que se maneje en fetchVideoId
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getVideoId(documentId),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se carga el futuro, puedes mostrar un indicador de carga u otra cosa
          return Center(child: CircularProgressIndicator(color: Colors.blue,));
        } else if (snapshot.hasError) {
          // Si hay un error, puedes mostrar un mensaje de error o manejarlo de otra manera
          return Text('Error: ${snapshot.error}');
        } else {
          // Si todo está bien, obtén el videoId y crea el reproductor de YouTube
          String videoId = snapshot.data ?? "";
          YoutubePlayerController controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );

          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(12.0), // Ajusta el radio según sea necesario
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(
                      0, 3), // Cambia el desplazamiento de la sombra según sea necesario
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
              ),
            ),
          );
        }
      },
    );
  }
}
