import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/constants.dart';
import '../models/formatage_date.dart';
import '../models/post.dart';
import '../services_firebase/service_firestore.dart';
import 'avatar.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(post.member),
      builder: (context, snapshot) {
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final profilePicture = data[profilePictureKey] ?? '';
        final name = data[nameKey] ?? '';
        final surname = data[surnameKey] ?? '';

        return Card(
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Avatar(radius: 15, imageUrl: profilePicture),
                            const SizedBox(width: 8),
                            Text(
                              '$name $surname',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(FormatageDate().formatted(post.date)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (post.image.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(post.image),
                          ),
                        const SizedBox(height: 12),
                        Text(post.text),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.star,
                        color:
                            (post.likes.contains(
                                  ServiceAuthentification().myId!,
                                ))
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text('${post.likes.length} likes'),
                    IconButton(onPressed: () {}, icon: Icon(Icons.messenger)),
                    const Text('Commenter'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
