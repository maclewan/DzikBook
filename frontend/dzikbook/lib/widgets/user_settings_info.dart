import 'package:flutter/material.dart';

class UserSettingsInfo extends StatelessWidget {
  final String propTitle, propDescription;
  final bool notEmpty;
  final void Function(BuildContext, String, String, String, String, String)
      editSetting;
  const UserSettingsInfo(
      {Key key,
      this.propTitle,
      this.propDescription,
      this.notEmpty,
      this.editSetting})
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
          editSetting(context, this.propTitle, "Aktualnie", "Nowe",
              "Wprowadź...", this.propDescription);
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
