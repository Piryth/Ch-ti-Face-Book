import 'dart:io';

import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:chti_face_book/services_firebase/service_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chti_face_book/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../models/membre.dart';
import '../models/post.dart';

class ServiceFirestore {
  static final instance = FirebaseFirestore.instance;

  final firestoreMember = instance.collection(memberCollectionKey);
  final firestorePost = instance.collection(postCollectionKey);

  addMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).set(data);
  }

  updateMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).update(data);
  }

  specificMember(String memberId) {
    return firestoreMember.doc(memberId).snapshots();
  }

  updateImage({
    required File file,
    required String folder,
    required String userId,
    required String imageName,
  }) {
    ServiceStorage()
        .addImage(
      file: file,
      folder: folder,
      userId: userId,
      imageName: imageName,
    )
        .then(
          (imageUrl) =>
      {
        updateMember(id: userId, data: {imageName: imageUrl}),
      },
    );
  }

  allPosts() {
    return firestorePost.orderBy(dateKey, descending: true).snapshots();
  }

  Future<bool> createPost({
    required Membre member,
    required String text,
    required XFile? image,
  }) async {
    final date = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> map = {
      memberIdKey: member.id,
      likesKey: [],
      dateKey: date,
      postKey: text,
    };

    if (image != null) {
      final url = await ServiceStorage().addImage(
        file: File(image.path),
        folder: postCollectionKey,
        userId: member.id,
        imageName: date.toString(),
      );
      map[postImageKey] = url;
    }

    await firestorePost.doc().set(map);
    return true;
  }

  postForMember(String memberId) => firestorePost.where(memberIdKey, isEqualTo: memberId).snapshots();

  allMembers() => firestoreMember.snapshots();

  addLike({required String memberID, required Post post}) async {
    if (post.likes.contains(memberID)) {
      post.reference.update({
        likesKey: FieldValue.arrayRemove([memberID]),
      });
    } else {
      post.reference.update({
        likesKey: FieldValue.arrayUnion([memberID]),
      });

    }
  }

  addComment({required Post post, required String text}) async {
    final memberId = ServiceAuthentification().myId;
    final date = DateTime.now().millisecondsSinceEpoch;

    if (memberId == null) return;

    Map<String, dynamic> map = {
      memberIdKey: memberId,
      commentTextKey: text,
      dateKey: date,
    };

    await post.reference.collection(commentCollectionKey).doc().set(map);
  }

  postComment(String postId) {
    return firestorePost
        .doc(postId)
        .collection(commentCollectionKey)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }


  sendNotification({
    required String to,
    required String from,
    required String text,
    required String postId,
  }) async {
    final date = DateTime.now().millisecondsSinceEpoch;
    final memberId = ServiceAuthentification().myId;

    if (memberId == null) return;

    Map<String, dynamic> map = {
      dateKey: date,
      isReadKey: false,
      fromKey: from,
      textKey: text,
      postIdKey: postId,
    };

    await firestoreMember
        .doc(to)
        .collection(notificationCollectionKey)
        .doc()
        .set(map);
  }

  markRead(DocumentReference reference) async {
    try {
      DocumentSnapshot documentSnapshot = await reference.get();

      if (documentSnapshot.exists) {
        bool currentIsRead = documentSnapshot.get(isReadKey) ?? false;

        await reference.update({isReadKey: !currentIsRead});
      }
    } catch (e) {
      debugPrintStack(label: 'Error toggling isRead: $e');
    }
  }

  notificationForUser(String id) {
    return firestoreMember
        .doc(id)
        .collection(notificationCollectionKey)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }

}