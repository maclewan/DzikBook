import 'package:dzikbook/providers/notifications.dart';
import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:dzikbook/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  static final String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<Notifications>(context, listen: false)
        .fetchNotifications()
        .then(
          (value) =>
              Provider.of<Notifications>(context, listen: false).readNotify(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<Notifications>(context).notifications;
    return Scaffold(
      appBar: buildNavBar(
        context: context,
        title: 'Notifications',
        routeName: NotificationsScreen.routeName,
      ),
      drawer: Drawer(
        child: DrawerBody(),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        itemBuilder: (context, index) => NotificationItem(
          notification: notifications[index],
        ),
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}
