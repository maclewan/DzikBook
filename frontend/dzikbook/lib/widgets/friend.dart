import 'package:flutter/material.dart';

class Friend extends StatelessWidget {
  final String userImg, userName, userId;
  const Friend({this.userImg, this.userName, this.userId});

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
                            height: 100,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FlatButton(
                                      minWidth: double.infinity,
                                      onPressed: () {},
                                      child: Text("Usuń ze znajomych")),
                                ),
                                Expanded(
                                  child: FlatButton(
                                      minWidth: double.infinity,
                                      onPressed: () {},
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
