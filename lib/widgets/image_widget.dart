import 'package:flutter/material.dart';
import 'package:nyimpang_cooperative/widgets/news_card.dart';

class ImageWidget extends StatelessWidget {
  final int index;

  const ImageWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 350,
    width: double.infinity,
    child: NewsCard(imageUrl: "https://nyimpang.com/wp-content/uploads/2023/06/FEED-REVIEW-TEMPLATE-1-5-750x536.png",
        title: "Gak Ada yang Benar-Benar Mulai dari Nol!",
        description: "SPBU pun tidak benar-benar dimulai dari nol. Karena masih ada sisa-sisa dari kendaraan yang mengisi sebelumnya.")
  );
}