import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {

  final double radius;
  final String imageUrl;

  static final String fallbackImageUrl = "assets/ChimpanziniBananini.webp"; // URL for the fallback image

  const Avatar({
    super.key,
    required this.radius,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {

    return imageUrl.isNotEmpty ?
     CircleAvatar(
      radius: radius.toDouble(),
      backgroundImage: NetworkImage(imageUrl),
    ) :
        CircleAvatar(
          radius: radius.toDouble(),
          backgroundColor: Colors.green,
        );
  }
}
