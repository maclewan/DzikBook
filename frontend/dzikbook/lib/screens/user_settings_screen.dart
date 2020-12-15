import 'package:dzikbook/widgets/navbar.dart';
import 'package:dzikbook/widgets/user_settings_info.dart';
import 'package:flutter/material.dart';

class _SingleSettingInfo {
  String title;
  String description;
  bool notEmpty;
  _SingleSettingInfo(this.title, this.description, this.notEmpty);
}

class UserSettingsScreeen extends StatefulWidget {
  UserSettingsScreeen({Key key}) : super(key: key);
  static const routeName = '/user-settings';

  @override
  _UserSettingsScreeenState createState() => _UserSettingsScreeenState();
}

class _UserSettingsScreeenState extends State<UserSettingsScreeen> {
  List<_SingleSettingInfo> settings;
  List<DialogInfo> dialogs;
  @override
  void initState() {
    settings = [
      _SingleSettingInfo("Nazwa siłowni", "", false),
      _SingleSettingInfo("Data urodzenia", "", false),
      _SingleSettingInfo("Data pierwszego treningu", "", false),
      _SingleSettingInfo("Płeć", "", false),
      _SingleSettingInfo("Nazwa firmy", "", false),
    ];

    super.initState();
  }

  void updateState(int id, String text) {
    setState(() {
      settings[id].description = text;
      settings[id].notEmpty = text.length > 0;
    });
  }

  void infoDialog(
      void Function(int, String) updateState,
      BuildContext context,
      String title,
      String currLabel,
      String futureLabel,
      String hintText,
      String currState) {
    showDialog(
        context: context,
        builder: (_) {
          TextEditingController controller = new TextEditingController();
          return AlertDialog(
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
                      controller: controller,
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Odrzuć")),
              FlatButton(
                child: Text("Akceptuj"),
                onPressed: () {
                  int id;
                  switch (title) {
                    case "Siłownia":
                      id = 0;
                      break;
                    case "Data urodzenia":
                      id = 1;
                      break;
                    case "Data pierwszego treningu":
                      id = 2;
                      break;
                    case "Płeć":
                      id = 3;
                      break;
                    case "Praca":
                      id = 4;
                      break;
                    default:
                      id = 0;
                  }
                  updateState(id, controller.text);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    dialogs = [
      DialogInfo("Siłownia", "Aktualna siłownia", "Nowa siłownia",
          "Podaj nazwę siłowni", settings[0].description),
      DialogInfo("Data urodzenia", "Aktualna data", "Nowa data",
          "Wprowadź datę DD/MM/RRRR", settings[1].description),
      DialogInfo("Data pierwszego treningu", "Aktualna data", "Nowa data",
          "Wprowadź datę DD/MM/RRRR", settings[2].description),
      DialogInfo("Płeć", "Aktualna płeć", "Nowa płeć", "Podaj płeć",
          settings[3].description),
      DialogInfo("Praca", "Aktualna nazwa firmy", "Nowa nazwa firmy",
          "Podaj nazwę firmy", settings[4].description),
    ];
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
            notEmpty: settings[0].notEmpty,
            propDescription: settings[0].description,
            propTitle: settings[0].title,
            editSetting: infoDialog,
            dialogInfo: dialogs[0],
            updateState: this.updateState,
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
            notEmpty: settings[1].notEmpty,
            propDescription: settings[1].description,
            propTitle: settings[1].title,
            editSetting: infoDialog,
            dialogInfo: dialogs[1],
            updateState: this.updateState,
          ),
          UserSettingsInfo(
            notEmpty: settings[2].notEmpty,
            propDescription: settings[2].description,
            propTitle: settings[2].title,
            editSetting: infoDialog,
            dialogInfo: dialogs[2],
            updateState: this.updateState,
          ),
          UserSettingsInfo(
            notEmpty: settings[3].notEmpty,
            propDescription: settings[3].description,
            propTitle: settings[3].title,
            editSetting: infoDialog,
            dialogInfo: dialogs[3],
            updateState: this.updateState,
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
            notEmpty: settings[4].notEmpty,
            propDescription: settings[4].description,
            propTitle: settings[4].title,
            editSetting: infoDialog,
            dialogInfo: dialogs[4],
            updateState: this.updateState,
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
