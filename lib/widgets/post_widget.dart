import 'dart:math';

import 'package:chti_face_book/pages/page_detail_post.dart';
import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:chti_face_book/widgets/post_content_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services_firebase/service_firestore.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          PostContent(post: post),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  ServiceFirestore().addLike(
                    memberID: FirebaseAuth.instance.currentUser!.uid,
                    post: post,
                  );

                  ServiceFirestore().sendNotification(
                    from: ServiceAuthentification().myId!,
                    to: post.member,
                    postId: post.id,
                    text:
                    "Vous avez reçu un like : ${post.text.substring(0, min(20, post.text.length))}...",
                  );
                },
                icon: Icon(
                  Icons.star,
                  color:
                      (post.likes.contains(ServiceAuthentification().myId!))
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text('${post.likes.length} likes'),
              IconButton(onPressed: () {
                final result = Navigator.push(context, MaterialPageRoute(builder: (context) => PageDetailPost(post: post),
                ));
              }, icon: Icon(Icons.messenger)),
              const Text('Commenter'),
            ],
          ),
        ],
      ),
    );
  }
}
