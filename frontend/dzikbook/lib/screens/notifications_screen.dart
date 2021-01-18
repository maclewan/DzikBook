import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  static final String routeName = '/notifiactions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildNavBar(
        context: context,
        title: 'Notifications',
        routeName: routeName,
      ),
      drawer: Drawer(
        child: DrawerBody(),
      ),
      body: ListView.builder(itemBuilder: null),
    );
  }
}
