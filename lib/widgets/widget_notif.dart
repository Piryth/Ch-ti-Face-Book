
import 'package:chti_face_book/models/notification.dart';
import 'package:chti_face_book/widgets/membre_header.dart';
import 'package:flutter/material.dart';

import '../services_firebase/service_firestore.dart';

class WidgetNotification extends StatefulWidget {
  const WidgetNotification({super.key, required this.notification});

  final NotificationModel notification;

  @override
  State<WidgetNotification> createState() => _WidgetNotificationState();
}

class _WidgetNotificationState extends State<WidgetNotification> {
  _markRead() {
    ServiceFirestore().markRead(widget.notification.reference);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _markRead,
      child: Card(
        shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
        child: Padding(padding: EdgeInsets.all(8), child: Column(
          children: [
            HeaderMembre(date: widget.notification.date, memberId: widget.notification.from),
            const Divider(thickness: 1),
            Row(
              children: [
                Text(widget.notification.text),
                const Spacer(),
                (widget.notification.isRead) ?
                Icon(Icons.check, color: Colors.blue, size: 16)
                    :
                Icon(Icons.check, color: Colors.grey, size: 16)

              ],
            )
          ],
        )),
      ),
    );
  }
}