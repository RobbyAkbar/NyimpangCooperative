import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const NewsCard({super.key, required this.imageUrl, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Ketebalan bayangan kartu
      margin: const EdgeInsets.all(8.0), // Jarak antara kartu
      child: Column(
        children: <Widget>[
          Image.network(
            imageUrl,
            height: 210,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0), // Jarak antara judul dan deskripsi
                Text(
                  description,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}