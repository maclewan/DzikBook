import 'package:flutter/material.dart';

import '../providers/notifications.dart';

class NotificationItem extends StatelessWidget {
  final NotificationClass notification;

  NotificationItem({this.notification});

  @override
  Widget build(BuildContext context) {
    Icon icon;
    switch (notification.type) {
      case 'invitation_send':
        icon = Icon(Icons.person_add);
        break;
      case 'invitation_accepted':
        icon = Icon(Icons.person);
        break;
      case 'like':
        icon = Icon(Icons.thumb_up);
        break;
      case 'comment':
        icon = Icon(Icons.comment);
        break;
      default:
    }
    return ListTile(
      title: Text(notification.title),
      subtitle: Text(notification.body),
      leading: icon,
    );
  }
}
