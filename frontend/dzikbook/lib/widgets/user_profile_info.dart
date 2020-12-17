import 'dart:io';

import 'package:dzikbook/screens/user_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileInfo extends StatefulWidget {
  final String userName, userImg;
  final bool rootUser, isFriend;
  const UserProfileInfo(
      {Key key,
      @required this.userImg,
      @required this.userName,
      @required this.rootUser,
      @required this.isFriend})
      : super(key: key);

  @override
  _UserProfileInfoState createState() => _UserProfileInfoState();
}

class _UserProfileInfoState extends State<UserProfileInfo> {
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: NetworkImage(this.widget.userImg),
                      fit: BoxFit.cover,
                      alignment: Alignment.center)),
              child: this.widget.rootUser
                  ? GestureDetector(
                      onTap: getImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          "EDYTUJ",
                          style: TextStyle(
                              color: Colors.grey[100],
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.green,
                              width: 1.5,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              this
                                  .widget
                                  .userName
                                  .replaceAll(new RegExp(r' '), '\n'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Posty",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text("15",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Treningi",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text("15",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Diety",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text("15",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            this.widget.rootUser
                                ? Navigator.of(context)
                                    .pushNamed(UserSettingsScreeen.routeName)
                                : print("test");
                          },
                          height: double.infinity,
                          minWidth: double.infinity,
                          child: this.widget.rootUser
                              ? FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "Ustawienia",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : this.widget.isFriend
                                  ? FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "Usuń znajomego",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "Dodaj do znajomych",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
