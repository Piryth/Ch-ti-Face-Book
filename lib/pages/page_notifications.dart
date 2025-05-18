import 'package:chti_face_book/widgets/widget_notif.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/membre.dart';
import '../models/notification.dart';
import '../services_firebase/service_firestore.dart';
import '../widgets/widget_vide.dart';

class PageNotifications extends StatefulWidget {
  final Membre membre;

  const PageNotifications({super.key, required this.membre});

  @override
  State<PageNotifications> createState() => _PageNotificationsState();
}

class _PageNotificationsState extends State<PageNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().notificationForUser(widget.membre.id),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const EmptyBody();
          }

          List<DocumentSnapshot> notifications = snapshot.data!.docs;

          return Skeletonizer(
            enabled: snapshot.connectionState == ConnectionState.waiting,
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = NotificationModel(
                  id: notifications[index].id,
                  reference: notifications[index].reference,
                  data: notifications[index].data() as Map<String, dynamic>,
                );
                return WidgetNotification(notification: notification);
              },
            ),
          );
        },
      ),
    );
  }
}
