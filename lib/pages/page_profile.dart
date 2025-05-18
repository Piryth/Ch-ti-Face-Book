import 'package:chti_face_book/models/post.dart';
import 'package:chti_face_book/pages/page_update_profil.dart';
import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:chti_face_book/services_firebase/service_firestore.dart';
import 'package:chti_face_book/widgets/avatar.dart';
import 'package:chti_face_book/widgets/bouton_camera.dart';
import 'package:chti_face_book/widgets/post_widget.dart';
import 'package:chti_face_book/widgets/widget_vide.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../util/constants.dart';
import '../models/membre.dart';

class PageProfil extends StatefulWidget {
  final Membre membre;

  // This flag determines whether we display this page from the navigation layout or standalone
  final bool fromNavigation;

  const PageProfil({
    super.key,
    required this.membre,
    required this.fromNavigation,
  });

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  late FToast fToast;

  Future<void> _navigate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(membre: widget.membre),
      ),
    );

    if (!context.mounted) return;

    if(result == true) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: const Text("Profil modifié avec succès !")),
        );
    }

  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          (widget.fromNavigation
              ? null
              : AppBar(title: Text(widget.membre.fullname))),
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().postForMember(widget.membre.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const EmptyBody();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          final docs = data!.docs;
          final length = docs.length ?? 0;

          final isMe = ServiceAuthentification().isMe(widget.membre.id);
          final indexToAdd = isMe ? 2 : 1;

          return ListView.builder(
            itemCount: length + indexToAdd,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                widget.membre.coverPicture.isEmpty
                                    ? Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                      child: const Center(),
                                    )
                                    : Image.network(
                                      widget.membre.coverPicture,
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                (isMe)
                                    ? BoutonCamera(
                                      membreId: widget.membre.id,
                                      type: coverPictureKey,
                                      membreImageUrl:
                                          widget.membre.profilePicture,
                                    )
                                    : const Center(),
                              ],
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Avatar(
                                radius: 75,
                                imageUrl: widget.membre.profilePicture,
                              ),
                            ),

                            (isMe)
                                ? BoutonCamera(
                                  membreId: widget.membre.id,
                                  type: profilePictureKey,
                                  membreImageUrl: widget.membre.profilePicture,
                                )
                                : const Center(),
                            // Button
                          ],
                        ),
                      ],
                    ),
                    Text(
                      widget.membre.fullname,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    Text(widget.membre.description),
                    (isMe)
                        ? OutlinedButton(
                          onPressed: () {
                            _navigate();
                          },
                          child: Text("Modifier mon profil"),
                        )
                        : const Center(),
                  ],
                );
              }
              if (index - indexToAdd >= 0) {
                final doc = docs[index - indexToAdd];

                final Post post = Post(
                  reference: doc.reference,
                  id: doc.id,
                  map: doc.data() as Map<String, dynamic>,
                );
                return PostWidget(post: post, key: ValueKey(post.id));
              }
              return const EmptyBody();
            },
          );
        },
      ),
    );
  }
}
