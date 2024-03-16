import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:kaiu/src/core/controllers/theme_controller.dart';

class ThreadsWidget extends StatefulWidget {
  final String documentId;
  const ThreadsWidget({super.key, required this.documentId});

  @override
  State<ThreadsWidget> createState() => _ThreadsWidgetState();
}

class _ThreadsWidgetState extends State<ThreadsWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getVideoId(widget.documentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitCubeGrid(
              size: 45,
              color: ThemeController.instance.exBackground(),
              duration: Duration(
                  milliseconds:
                      500)); // O cualquier indicador de carga que desees mostrar
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final videoId = snapshot.data!;
          bool _isAudioPlaying = false;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Color.fromARGB(76, 44, 44, 44),
            ),
            padding: EdgeInsets.all(5.0),
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PostCard(
                  username: '@UltraBrother M78',
                  postText: '¡Mi video más reciente!',
                  linkImage: 'assets/Youtube_logo.png',
                  onTap: () {
                    applaunchUrl("https://www.youtube.com/watch?v=$videoId");
                  },
                ),
                PostCard(
                  username: '¡Mantén Kaiu Actualizado!',
                  postText: 'Visita Google Play',
                  linkImage: 'assets/GooglePlay.png',
                  onTap: () {
                    applaunchUrl(
                        "https://play.google.com/store/search?q=kaiu&c=apps&hl=es_PE&gl=US");
                  },
                ),
                PostCard(
                  username: '@Ultraman',
                  postText: '¡Este es el Kaiju más votado!',
                  linkImage: 'assets/zetton_home.webp',
                  //_isAudioPlaying se inicializa en Falso
                  onTap: () async {
                    if (_isAudioPlaying) return; //Si fuera verdadero la funcion no hace nada.  
                    _isAudioPlaying = true; // Si se ignora lo anterior AudioPlaying es verdadero. 
                    
                    //Traemos el Audio. 
                    final player = AudioPlayer();
                    await player.play(UrlSource("https://firebasestorage.googleapis.com/v0/b/kaiu-8295c.appspot.com/o/Audio%2FZetton_Roar.ogg?alt=media&token=f7a16298-28a2-434b-89c7-9ee7f37b946b"));
                    
                    //Solo si el Audio está completo haremos que que _isAudioPlaying sea Falso.
                    player.onPlayerStateChanged.listen((state) {
                      if (state == PlayerState.completed) {
                        _isAudioPlaying = false;
                      }
                    });
                  },
                ),
                // Add more posts here if needed
              ],
            ),
          );
        }
      },
    );
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
      throw e; // Propagar el error para que se maneje en el FutureBuilder
    }
  }
}

class PostCard extends StatelessWidget {
  final String username;
  final String postText;
  final int likes;
  final int comments;
  final String linkImage;
  final Function()? onTap;

  PostCard({
    required this.username,
    required this.postText,
    required this.linkImage,
    this.likes = 0,
    this.comments = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: ThemeController.instance.backgroundThreads(),
        margin: EdgeInsets.all(10.0),
        child: SizedBox(
          width: 125, // Establece el ancho de cada tarjeta
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: ThemeController.instance.textPrimary(),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 8),
                Flexible(
                  // o Expanded
                  child: Text(
                    postText,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: ThemeController.instance.textPrimary(),
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ), // Se truncará el texto si es demasiado largo
                    // maxLines: 3, // Ajusta el número de líneas que mostrará el texto
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12.0), // Match border radius
                    child: Image.asset(
                      fit: BoxFit.cover,
                      linkImage,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
