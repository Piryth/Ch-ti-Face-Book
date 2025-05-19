import 'package:chti_face_book/models/commentaire.dart';
import 'package:chti_face_book/util/formatage_date.dart';
import 'package:chti_face_book/models/membre.dart';
import 'package:chti_face_book/services_firebase/service_firestore.dart';
import 'package:chti_face_book/widgets/avatar.dart';
import 'package:chti_face_book/widgets/widget_vide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentaireTile extends StatelessWidget {
  final Commentaire commentaire;
  final String memberId;

  const CommentaireTile({
    super.key,
    required this.memberId,
    required this.commentaire,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ServiceFirestore().specificMember(memberId),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot,
      ) {
        if (snapshot.hasData) {
          final data = snapshot.data!;

          final Membre membre = Membre(
            id: memberId,
            reference: data.reference,
            map: data.data() as Map<String, dynamic>,
          );

          return ListTile(
              leading: Avatar(radius: 48, imageUrl: membre.profilePicture),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(membre.fullname), Text(FormatageDate().formatted(commentaire.date), style: TextStyle(color: Colors.grey, fontSize: 12))],
              ),
              subtitle: Text(commentaire.text),
            );
        }

        return const EmptyBody();
      },
    );
  }
}
