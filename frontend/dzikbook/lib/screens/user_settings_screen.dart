import 'package:flutter/material.dart';

class UserSettingsScreeen extends StatefulWidget {
  UserSettingsScreeen({Key key}) : super(key: key);

  @override
  _UserSettingsScreeenState createState() => _UserSettingsScreeenState();
}

class _UserSettingsScreeenState extends State<UserSettingsScreeen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "Informacje o Tobie",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
