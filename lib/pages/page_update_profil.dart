import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:flutter/material.dart';

import '../util/constants.dart';
import '../models/membre.dart';
import '../services_firebase/service_firestore.dart';

class UpdateProfilePage extends StatefulWidget {

  final Membre membre;
  const UpdateProfilePage({super.key, required this.membre});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController _surnameController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool hasChanged = false;


  Future<void> _validate(BuildContext ctx) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> map = {};

    if (_nameController.text.isNotEmpty && _nameController.text != widget.membre.name) {
      map[nameKey] = _nameController.text;
      hasChanged = true;
    }

    if (_surnameController.text.isNotEmpty && _surnameController.text != widget.membre.surname) {
      map[surnameKey] = _surnameController.text;
      hasChanged = true;
    }

    if (_descriptionController.text.isNotEmpty && _descriptionController.text != widget.membre.description) {
      map[descriptionKey] = _descriptionController.text;
      hasChanged = true;
    }
    ServiceFirestore().updateMember(id: widget.membre.id, data: map);
    Navigator.pop(ctx, hasChanged);
  }

  @override
  void initState() {
    super.initState();
    _surnameController = TextEditingController(text: widget.membre.surname);
    _nameController = TextEditingController(text: widget.membre.name);
    _descriptionController = TextEditingController(text: widget.membre.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le profil"),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed:(){ _validate(context);}),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          
          child: Padding(padding: EdgeInsets.all(8), child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Please enter your name',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Surname',
                  hintText: 'Please enter your surname',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                controller: _surnameController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Please provide a description',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                controller: _descriptionController,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context, false);
                  await ServiceAuthentification().signOut();
                },
                child: const Text("Se déconnecter"),
              ),
            ],
          )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
