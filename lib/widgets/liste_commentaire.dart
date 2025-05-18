import 'package:chti_face_book/models/commentaire.dart';
import 'package:chti_face_book/services_firebase/service_firestore.dart';
import 'package:chti_face_book/widgets/avatar.dart';
import 'package:chti_face_book/widgets/commentaire_tile.dart';
import 'package:chti_face_book/widgets/widget_vide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/constants.dart';
import '../models/post.dart';

class ListeCommentaire extends StatelessWidget {
  final Post post;

  const ListeCommentaire({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ServiceFirestore().postComment(post.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if(snapshot.hasData) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              final String memberId = document[memberIdKey];
              final commentaire = Commentaire(id: document.id, reference: document.reference, map: document.data() as Map<String, dynamic>);

              return CommentaireTile(memberId: memberId, commentaire: commentaire);
            },
          );
        }

        return EmptyBody();


      },
    );
  }
}
