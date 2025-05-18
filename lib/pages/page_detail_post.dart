import 'dart:math';
import 'package:chti_face_book/services_firebase/service_authentification.dart';
import 'package:chti_face_book/widgets/liste_commentaire.dart';
import 'package:chti_face_book/widgets/post_content_widget.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services_firebase/service_firestore.dart';

class PageDetailPost extends StatefulWidget {
  const PageDetailPost({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PageDetailPost> createState() => _PostPageDetailState();
}

class _PostPageDetailState extends State<PageDetailPost> {
  final TextEditingController _commentController = TextEditingController();

  _addComment() {
    final comment = _commentController.text;

    if (comment.isNotEmpty) {
      ServiceFirestore().addComment(post: widget.post, text: comment);
      ServiceFirestore().sendNotification(
        from: ServiceAuthentification().myId!,
        to: widget.post.member,
        postId: widget.post.id,
        text:
        "Nouveau commentaire: ${widget.post.text.substring(0, min(20, widget.post.text.length))}...",
      );
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Commentaires"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [
            PostContent(post: widget.post),

            ListeCommentaire(post: widget.post),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: "Commentaire",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(onPressed: _addComment, icon: Icon(Icons.send)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

}
