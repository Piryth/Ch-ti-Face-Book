import 'package:chti_face_book/widgets/skeleton_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../util/constants.dart';
import '../util/formatage_date.dart';
import '../models/post.dart';
import '../services_firebase/service_firestore.dart';
import 'avatar.dart';

class PostContent extends StatelessWidget {
  final Post post;

  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(post.member),
      builder: (context, snapshot) {

        if (!snapshot.hasData || snapshot.hasError) {
          return Center();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final profilePicture = data[profilePictureKey] ?? '';
        final name = data[nameKey] ?? '';
        final surname = data[surnameKey] ?? '';

        return Skeletonizer(enabled: snapshot.connectionState == ConnectionState.waiting, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Avatar(radius: 18, imageUrl: profilePicture),
                  const SizedBox(width: 8),
                  Text(
                    '$name $surname',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(FormatageDate().formatted(post.date)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(post.text),
            const SizedBox(height: 12),
            if (post.image.isNotEmpty)
              ClipRRect(child: Image.network(post.image)),
            const SizedBox(height: 12),
          ],
        )) ;
      },
    );
  }
}
