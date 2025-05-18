import 'dart:io';

import 'package:chti_face_book/util/constants.dart';
import 'package:chti_face_book/services_firebase/service_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BoutonCamera extends StatelessWidget {

  final String membreId;
  final String type;
  final String membreImageUrl;

  const BoutonCamera({super.key, required this.membreId,required this.type, required this.membreImageUrl});

  _takePhoto(ImageSource source, String type) async {
    final XFile? xFile = await ImagePicker().pickImage(
        source: source, maxWidth: 500);
    if (xFile == null) return;
    ServiceFirestore().updateImage(file: File(xFile.path),
        folder: memberCollectionKey,
        userId: membreId,
        imageName: type);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () => _takePhoto(ImageSource.camera, type), icon: const Icon(Icons.camera_alt));
  }
}
