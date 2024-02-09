import 'package:flutter/material.dart';
import 'package:kaiu/src/core/models/kaiju.dart';

class KaijuPostList extends StatefulWidget {
  final Kaiju kaiju;
  const KaijuPostList({super.key, required this.kaiju});

  @override
  State<KaijuPostList> createState() => _KaijuPostState();
}

class _KaijuPostState extends State<KaijuPostList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget
          .kaiju.kaijuHabs?.length, // Puedes ajustar la cantidad de posts aquí
      itemBuilder: (context, index) {
        return KaijuPost(kaiju: widget.kaiju, index: index);
      },
    );
  }
}

class KaijuPost extends StatelessWidget {
  final Kaiju kaiju;
  final int index;
  const KaijuPost({super.key, required this.kaiju, required this.index});

  @override
  Widget build(BuildContext context) {
    var kaijuHabsInfo = kaiju.kaijuHabs?.values.toList()[index];

    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado del post (foto de perfil, nombre de usuario, tiempo y público)
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  "assets/${kaiju.ultra}_avatar.jpg"), // Cambia la URL de la foto de perfil
            ),
            title: Text(kaiju.ultra),
            subtitle: Row(
              children: [
                Icon(
                  Icons.public,
                  color: Colors.black.withOpacity(0.5),
                  size: 20,
                ), // Icono "mundo" para indicar que es público
                SizedBox(width: 4),
                Text(kaijuHabsInfo["timeAgo"]), // Tiempo del post
              ],
            ),
          ),

          // Descripción superior del post (título o descripción)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset(
                  'assets/bullet_point_text.png',
                  width: 30, // Ajusta el ancho según tus preferencias
                  height: 30, // Ajusta la altura según tus preferencias
                  // ... other properties ...
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    kaijuHabsInfo["name"] ?? "",
                    overflow:
                        TextOverflow.fade, // ¿Como se maneja el desbordamiento?
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Imagen principal del post
          Image.network(
            kaijuHabsInfo["image"] ?? "-", // Cambia la URL de la imagen
            fit: BoxFit.cover,
          ),

          // Contenido del post
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Descripción del post
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    kaijuHabsInfo["description"],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
