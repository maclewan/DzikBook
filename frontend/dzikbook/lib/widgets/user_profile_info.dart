import 'dart:io';

import 'package:dzikbook/providers/friends.dart';
import 'package:dzikbook/providers/search_people.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/screens/user_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileInfo extends StatefulWidget {
  final String userName, userImg, userId;
  final bool rootUser, isFriend;
  final int postsCount, trainingsCount, dietsCount;
  const UserProfileInfo({
    Key key,
    @required this.userId,
    @required this.userImg,
    @required this.userName,
    @required this.rootUser,
    @required this.isFriend,
    @required this.postsCount,
    @required this.trainingsCount,
    @required this.dietsCount,
  }) : super(key: key);

  @override
  _UserProfileInfoState createState() => _UserProfileInfoState();
}

class _UserProfileInfoState extends State<UserProfileInfo> {
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<UserData>(context, listen: false)
          .changeProfilePicture(File(pickedFile.path))
          .then((res) {
        if (res) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      });
    }
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
                      image: NetworkImage(this.widget.rootUser
                          ? Provider.of<UserData>(context, listen: false)
                              .imageUrl
                          : this.widget.userImg),
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
                              Text(this.widget.postsCount.toString(),
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
                            Text(this.widget.trainingsCount.toString(),
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
                            Text(this.widget.dietsCount.toString(),
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
                            if (this.widget.rootUser) {
                              Navigator.of(context)
                                  .pushNamed(UserSettingsScreeen.routeName);
                            } else if (this.widget.isFriend) {
                              final friendsProvider =
                                  Provider.of<Friends>(context, listen: false);
                              friendsProvider
                                  .deleteUserFromFriends(this.widget.userId)
                                  .then((response) {
                                print(response);
                                Navigator.of(context).pop();
                              });
                            } else if (!this.widget.isFriend) {
                              final searchPeopleProvider =
                                  Provider.of<SearchPeople>(context,
                                      listen: false);
                              searchPeopleProvider
                                  .sendFriendRequest(this.widget.userId)
                                  .then((response) {
                                print(response);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Zaproszenie'),
                                        content: Text(
                                            '${!response ? "BŁĄD! Nie zaproszono " : "Zaproszono "} do znajomych!'),
                                        actions: [
                                          TextButton(
                                            child: Text('Zrozumiano'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    }).then((_) => Navigator.of(context).pop());
                              });
                            }
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
