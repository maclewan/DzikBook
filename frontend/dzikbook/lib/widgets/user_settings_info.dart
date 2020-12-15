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
  final void Function(void Function(int, String), BuildContext, String, String,
      String, String, String) editSetting;
  final void Function(int, String) updateState;
  const UserSettingsInfo(
      {Key key,
      this.propTitle,
      this.propDescription,
      this.notEmpty,
      this.editSetting,
      this.dialogInfo,
      this.updateState})
      : super(key: key);

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
              this.updateState,
              context,
              this.dialogInfo.title,
              this.dialogInfo.currLabel,
              this.dialogInfo.futureLabel,
              this.dialogInfo.hintText,
              this.dialogInfo.currState);
        },
      ),
    );
    // return !this.notEmpty
    //     ? Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(this.propTitle,
    //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
    //           FlatButton(
    //               onPressed: () {},
    //               child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Icon(
    //                       Icons.add,
    //                       color: Colors.green,
    //                     ),
    //                     Text(this.propDescription,
    //                         style: TextStyle(
    //                             fontSize: 14, color: Colors.grey[600]))
    //                   ]))
    //         ],
    //       )
    //     : Container();
  }
}
