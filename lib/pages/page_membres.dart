import 'package:chti_face_book/pages/page_profile.dart';
import 'package:chti_face_book/services_firebase/service_firestore.dart';
import 'package:chti_face_book/widgets/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/membre.dart';
import '../widgets/skeleton_list_tile.dart';
import '../widgets/widget_vide.dart';

class PageMembre extends StatefulWidget {
  const PageMembre({super.key});

  @override
  State<PageMembre> createState() => _PageMembreState();
}

class _PageMembreState extends State<PageMembre> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ServiceFirestore().allMembers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.separated(
            itemBuilder: (context, index) {
              return SkeletonListTile();
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: 3, // You can adjust the number of skeleton items
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const EmptyBody();
        }

        final data = snapshot.data;
        final docs = data?.docs;

        final membres =
            docs
                !.map(
                  (item) => Membre(
                    reference: item.reference,
                    id: item.id,
                    map: item.data() as Map<String, dynamic>,
                  ),
                )
                .toList();

        return ListView.separated(
          itemBuilder: (context, index) {
            final Membre currentMember = membres[index];
            return ListTile(
              title: Text(membres[index].fullname),
              subtitle: Text(membres[index].description),
              leading: Avatar(
                radius: 26,
                imageUrl: membres[index].profilePicture,
              ),
              onTap:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => PageProfil(
                              membre: membres[index],
                              fromNavigation: false,
                            ),
                      ),
                    ),
                  },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: membres.length,
        );
      },
    );
  }
}
