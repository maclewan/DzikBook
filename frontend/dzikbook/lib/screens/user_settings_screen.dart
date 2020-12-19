import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:dzikbook/widgets/user_settings_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void infoDialog(BuildContext context, String title, String currLabel,
      String futureLabel, String hintText, String currState) {
    showDialog(
        context: context,
        builder: (_) {
          final userDataProvider =
              Provider.of<UserData>(context, listen: false);
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
                      userDataProvider
                          .changeUserData(
                              newGym: controller.text,
                              newBirthDate: userDataProvider.birthDate,
                              newJob: userDataProvider.job,
                              newSex: userDataProvider.sex)
                          .then((response) {
                        Navigator.of(context).pop();
                      });
                      break;
                    case "Data urodzenia":
                      userDataProvider
                          .changeUserData(
                              newGym: userDataProvider.gym,
                              newBirthDate: controller.text,
                              newJob: userDataProvider.job,
                              newSex: userDataProvider.sex)
                          .then((response) {
                        Navigator.of(context).pop();
                      });
                      break;
                    case "Płeć":
                      userDataProvider
                          .changeUserData(
                              newGym: userDataProvider.gym,
                              newBirthDate: userDataProvider.birthDate,
                              newJob: userDataProvider.job,
                              newSex: controller.text)
                          .then((response) {
                        Navigator.of(context).pop();
                      });
                      break;
                    case "Praca":
                      userDataProvider
                          .changeUserData(
                              newGym: userDataProvider.gym,
                              newBirthDate: userDataProvider.birthDate,
                              newJob: controller.text,
                              newSex: userDataProvider.sex)
                          .then((response) {
                        Navigator.of(context).pop();
                      });
                      break;
                    default:
                      Navigator.of(context).pop();
                  }
                  // updateState(id, controller.text);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserData>(context, listen: true);
    settings = [
      _SingleSettingInfo("Nazwa siłowni", userDataProvider.gym,
          userDataProvider.gym.length > 0),
      _SingleSettingInfo("Data urodzenia", userDataProvider.birthDate,
          userDataProvider.birthDate.length > 0),
      _SingleSettingInfo(
          "Płeć", userDataProvider.sex, userDataProvider.sex.length > 0),
      _SingleSettingInfo(
          "Nazwa firmy", userDataProvider.job, userDataProvider.job.length > 0),
    ];
    dialogs = [
      DialogInfo("Siłownia", "Aktualna siłownia", "Nowa siłownia",
          "Podaj nazwę siłowni", settings[0].description),
      DialogInfo("Data urodzenia", "Aktualna data", "Nowa data",
          "Wprowadź datę DD/MM/RRRR", settings[1].description),
      DialogInfo("Płeć", "Aktualna płeć", "Nowa płeć", "Podaj płeć",
          settings[2].description),
      DialogInfo("Praca", "Aktualna nazwa firmy", "Nowa nazwa firmy",
          "Podaj nazwę firmy", settings[3].description),
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
          ),
          UserSettingsInfo(
            notEmpty: settings[2].notEmpty,
            propDescription: settings[2].description,
            propTitle: settings[2].title,
            editSetting: infoDialog,
            dialogInfo: dialogs[2],
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
            notEmpty: settings[3].notEmpty,
            propDescription: settings[3].description,
            propTitle: settings[3].title,
            editSetting: infoDialog,
            dialogInfo: dialogs[3],
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
