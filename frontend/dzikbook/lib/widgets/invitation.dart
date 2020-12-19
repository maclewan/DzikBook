import 'package:dzikbook/providers/friends.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Invitation extends StatelessWidget {
  final String userImg, userName, userId, invitationId;
  const Invitation(
      {this.userImg, this.userName, this.userId, this.invitationId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Tap'),
          ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(this.userImg),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    this.userName,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 25,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 150,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FlatButton(
                                      minWidth: double.infinity,
                                      onPressed: () {
                                        Provider.of<Friends>(context,
                                                listen: false)
                                            .acceptFriendRequest(
                                                this.invitationId)
                                            .then((response) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text("Akceptuj zaproszenie")),
                                ),
                                Expanded(
                                  child: FlatButton(
                                      minWidth: double.infinity,
                                      onPressed: () {
                                        Provider.of<Friends>(context,
                                                listen: false)
                                            .denyFriendRequest(
                                                this.invitationId)
                                            .then((response) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text("Odrzuć zaproszenie")),
                                ),
                                Expanded(
                                  child: FlatButton(
                                      minWidth: double.infinity,
                                      onPressed: () {
                                        final userDataProvider =
                                            Provider.of<UserData>(context,
                                                listen: false);
                                        userDataProvider
                                            .getAnotherUserData(this.userId)
                                            .then((data) {
                                          print(data);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileScreen(
                                                        postsCount:
                                                            data.posts[0],
                                                        trainingsCount:
                                                            data.posts[1],
                                                        dietsCount:
                                                            data.posts[2],
                                                        id: this.userId,
                                                        friend: data.isFriend,
                                                        rootUser: false,
                                                        userImage: data.image,
                                                        userName: data.name,
                                                      )));
                                        });
                                      },
                                      child: Text("Pokaż profil")),
                                ),
                              ],
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
