import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class Commentaire {
  DocumentReference reference;
  String id;
  Map<String, dynamic> map;

  Commentaire({required this.reference, required this.id, required this.map});

  String get member => map[memberIdKey] ?? "";
  String get text => map[commentTextKey] ?? "";
  int get date => map[dateKey] ?? 0;
}