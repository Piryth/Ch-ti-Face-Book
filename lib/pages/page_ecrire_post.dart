import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/membre.dart';
import '../services_firebase/service_firestore.dart';

class PageEcrirePost extends StatefulWidget {
  final Membre membre;

  const PageEcrirePost({super.key, required this.membre});

  @override
  State<PageEcrirePost> createState() => _PageEcrirePostState();
}

class _PageEcrirePostState extends State<PageEcrirePost> {
  final TextEditingController _postContentController = TextEditingController();
  XFile? xFile;

  void _sendPost() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (xFile == null && _postContentController.text.isEmpty) return;

    try {
      bool success = await ServiceFirestore().createPost(
        member: widget.membre,
        text: _postContentController.text,
        image: xFile,
      );

      if(success) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: const Text("Post uploadé avec succès !")));
      }

      _postContentController.clear();
      setState(() {
        xFile = null;
      });
    } catch (e) {
      debugPrint('Post cannot be uploaded : $e');
    }
  }

  Future<void> _takePick(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );
    if (image != null) {
      setState(() {
        xFile = XFile(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.border_color,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Écrire un post',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      TextField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Post',
                          hintText: 'Contenu du post',
                          prefixIcon: Icon(Icons.edit),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        controller: _postContentController,
                      ),
                      const SizedBox(height: 10),
                      if (xFile != null)
                        Image.file(
                          File(xFile!.path),
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.photo_library),
                            onPressed: () => _takePick(ImageSource.gallery),
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () => _takePick(ImageSource.camera),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(onPressed: () async => {
                        _sendPost()
                      }, child: Text("Envoyer")),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
