import 'package:chti_face_book/models/post.dart';
import 'package:chti_face_book/services_firebase/service_firestore.dart';
import 'package:chti_face_book/widgets/post_widget.dart';
import 'package:chti_face_book/widgets/widget_vide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PageAccueil extends StatelessWidget {
  final ServiceFirestore _serviceFirestore = ServiceFirestore();

  PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _serviceFirestore.allPosts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData ||
              snapshot.hasError) {
            return const EmptyBody();
          }

          return Skeletonizer(enabled : snapshot.connectionState == ConnectionState.waiting ,child: Padding(
            padding: EdgeInsets.all(0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                Post post = Post(
                  reference: doc.reference,
                  id: doc.id,
                  map: doc.data() as Map<String, dynamic>,
                );
                return PostWidget(post: post);
              },
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
          ));
        },
      ),
    );
  }
}
