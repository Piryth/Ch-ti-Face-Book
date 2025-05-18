import 'package:chti_face_book/pages/page_accueil.dart';
import 'package:chti_face_book/pages/page_authentification.dart';
import 'package:chti_face_book/pages/page_ecrire_post.dart';
import 'package:chti_face_book/pages/page_membres.dart';
import 'package:chti_face_book/pages/page_notifications.dart';
import 'package:chti_face_book/pages/page_profile.dart';
import 'package:chti_face_book/widgets/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/membre.dart';
import '../services_firebase/service_authentification.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart';

class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  ServiceAuthentification serviceAuthentification = ServiceAuthentification();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final memberId = serviceAuthentification.myId;

    return (memberId == null)
        ? const EmptyScaffold()
        : StreamBuilder<DocumentSnapshot>(
          stream: ServiceFirestore().specificMember(memberId),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.hasData) {
              final data = snapshot.data!;

              if (data.data() == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageAuthentification(),
                  ),
                );
              }

              final Membre membre = Membre(
                reference: data.reference,
                id: memberId,
                map: data.data() as Map<String, dynamic>,
              );

              List<Widget> bodies = [
                PageAccueil(),
                PageMembre(),
                PageEcrirePost(membre: membre),
                PageNotifications(membre: membre),
                PageProfil(membre: membre, fromNavigation: true),
              ];

              return Scaffold(
                appBar: AppBar(
                  leading: Padding(
                    padding: EdgeInsets.all(8),
                    child: Avatar(radius: 18, imageUrl: membre.profilePicture),
                  ),
                  title: Text(
                    membre.fullname,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () async {
                        await serviceAuthentification.signOut();
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: NavigationBar(
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  selectedIndex: index,
                  onDestinationSelected: (int newValue) {
                    setState(() {
                      index = newValue;
                    });
                  },
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: "Accueil",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.group),
                      label: "Membres",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.border_color),
                      label: "Ecrire",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.notifications),
                      label: "Notifications",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person),
                      label: "Profil",
                    ),
                  ],
                ),
                body: bodies[index],
              );
            } else {
              return const EmptyScaffold();
            }
          },
        );
  }
}
