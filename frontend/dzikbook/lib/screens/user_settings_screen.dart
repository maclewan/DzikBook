import 'package:dzikbook/widgets/navbar.dart';
import 'package:dzikbook/widgets/user_settings_info.dart';
import 'package:flutter/material.dart';

class UserSettingsScreeen extends StatefulWidget {
  UserSettingsScreeen({Key key}) : super(key: key);
  static const routeName = '/user-settings';

  @override
  _UserSettingsScreeenState createState() => _UserSettingsScreeenState();
}

class _UserSettingsScreeenState extends State<UserSettingsScreeen> {
  TextEditingController myController;
  void infoDialog(BuildContext context, String title, String currLabel,
      String futureLabel, String hintText, String currState) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Container(
          width: 500,
          height: 150,
          child: ListView(
            children: [
              ListTile(
                title: Text(currState),
                subtitle: Text(currLabel),
              ),
              ListTile(
                title: TextFormField(
                  controller: myController,
                  decoration: InputDecoration(
                      alignLabelWithHint: true, hintText: hintText),
                ),
                subtitle: Text(futureLabel),
              )
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text("Akceptuj"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildNavBar(context: context, routeName: '', title: ""),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 30),
            child: Text(
              "Informacje o Tobie",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("Siłownia",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
          UserSettingsInfo(
            notEmpty: false,
            propDescription: "",
            propTitle: "Nazwa siłowni",
            editSetting: infoDialog,
          ),
          Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("Podstawowe informacje",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
          UserSettingsInfo(
            notEmpty: false,
            propDescription: "",
            propTitle: "Data urodzenia",
            editSetting: infoDialog,
          ),
          UserSettingsInfo(
            notEmpty: false,
            propDescription: "",
            propTitle: "Data pierwszego treningu",
            editSetting: infoDialog,
          ),
          UserSettingsInfo(
            notEmpty: false,
            propDescription: "",
            propTitle: "Płeć",
            editSetting: infoDialog,
          ),
          Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("Praca",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
          UserSettingsInfo(
            notEmpty: false,
            propDescription: "",
            propTitle: "Nazwa firmy",
            editSetting: infoDialog,
          ),
          Divider(color: Colors.grey[600]),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
