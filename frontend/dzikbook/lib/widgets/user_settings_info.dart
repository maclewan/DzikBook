import 'package:flutter/material.dart';

class DialogInfo {
  final String title;
  final String currLabel;
  final String futureLabel;
  final String hintText;
  final String currState;

  DialogInfo(this.title, this.currLabel, this.futureLabel, this.hintText,
      this.currState);
}

class UserSettingsInfo extends StatelessWidget {
  final String propTitle, propDescription;
  final bool notEmpty;
  final DialogInfo dialogInfo;
  final void Function(BuildContext, String, String, String, String, String)
      editSetting;
  const UserSettingsInfo({
    Key key,
    this.propTitle,
    this.propDescription,
    this.notEmpty,
    this.editSetting,
    this.dialogInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: this.notEmpty ? Text(this.propDescription) : Text("Wprowadź dane"),
      subtitle: Text(this.propTitle, style: TextStyle(color: Colors.grey[500])),
      trailing: TextButton(
        child: Text(
          'Edytuj',
          style: TextStyle(color: Colors.green),
        ),
        onPressed: () {
          editSetting(
              context,
              this.dialogInfo.title,
              this.dialogInfo.currLabel,
              this.dialogInfo.futureLabel,
              this.dialogInfo.hintText,
              this.dialogInfo.currState);
        },
      ),
    );
  }
}
