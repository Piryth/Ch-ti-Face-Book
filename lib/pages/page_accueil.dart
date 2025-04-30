import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageAccueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chti Face Bouc")),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          return snapshot.hasData ?
              const Center(child: Text("Connecté")) :
              const Center(child: Text("Non Connecté"));
        },
      ),
    );
  }
}
