import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String documentId;

  const YoutubePlayerScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen>
    with AutomaticKeepAliveClientMixin {
  
  late Future<String> _videoIdFuture;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _videoIdFuture = getVideoId(widget.documentId);
  }

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
      // print('Error al obtener el ID del video: $e');
      throw e; // Propagar el error para que se maneje en fetchVideoId
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Importante llamar a super.build(context)

    return FutureBuilder(
      future: _videoIdFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se carga el futuro, puedes mostrar un indicador de carga u otra cosa
          return Center(
            child: SpinKitCubeGrid(
                size: 30,
                color: ThemeController.instance.exBackground(),
                duration: Duration(milliseconds: 1000)),
          );
        } else if (snapshot.hasError) {
          // Si hay un error, puedes mostrar un mensaje de error o manejarlo de otra manera
          return Text('Error: ${snapshot.error}');
        } else {
          // Si todo está bien, obtén el videoId y crea el reproductor de YouTube
          String videoId = snapshot.data ?? "";
          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );

          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    12.0), // Ajusta el radio según sea necesario
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 250, 0, 0).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0,
                        3), // Cambia el desplazamiento de la sombra según sea necesario
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Text("En Mantenimiento",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                // child: YoutubePlayer(
                //   controller: _controller,
                //   showVideoProgressIndicator: true,
                //   progressIndicatorColor: Colors.blueAccent,
                // ),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true; // Mantén el estado del widget

}
