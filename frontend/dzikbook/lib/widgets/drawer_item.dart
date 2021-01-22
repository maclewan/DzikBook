import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeName;

  DrawerItem({this.icon, this.routeName, this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushReplacementNamed(this.routeName, arguments: false);
      },
      leading: Icon(
        this.icon,
        size: 30,
      ),
      title: Text(
        this.title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
