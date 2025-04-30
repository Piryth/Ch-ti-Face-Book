import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:flutter/material.dart';

class PageAccueil extends StatelessWidget {

  final ServiceAuthentification _serviceAuthentification = ServiceAuthentification();

  PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Chti Face Bouc"),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  _serviceAuthentification.signOut();
                },
                icon: Icon(Icons.logout),
                color: Colors.white,
              )
              ]
        )
    );
  }
}
