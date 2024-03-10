import 'package:flutter/material.dart';
import 'package:kaiu/src/core/constants/functions.dart';
import 'package:path/path.dart';

class ThreadsWidget extends StatelessWidget {
  const ThreadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 200),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          PostCard(
            username: 'ahmedmo...',
            postText: 'Best feeling ❤️',
            likes: 3170,
            comments: 22,
          ),
          PostCard(
            username: 'jharenblas',
            postText: 'Oh, we thought it was February 29th ahahaha 😌',
          ),
          PostCard(
            username: 'jharenblas',
            postText: 'Oh, we thought it was February 29th ahahaha 😌',
          ),
          PostCard(
            username: 'jharenblas',
            postText: 'Oh, we thought it was February 29th ahahaha 😌',
          ),
          // Add more posts here if needed
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String username;
  final String postText;
  final int likes;
  final int comments;

  PostCard({
    required this.username,
    required this.postText,
    this.likes = 0,
    this.comments = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorFromHex("#333436"),
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Flexible( // o Expanded
                child: Text(
                  postText,
                  overflow: TextOverflow.ellipsis, // Se truncará el texto si es demasiado largo
                  // maxLines: 3, // Ajusta el número de líneas que mostrará el texto
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text('$likes likes')),
                  Flexible(child: Text('$comments comments')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
