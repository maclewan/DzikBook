import 'package:dzikbook/widgets/friend.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';

class FriendsListScreen extends StatefulWidget {
  static final routeName = '/friends-list';

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _Friend {
  final String id, userImg, userName;

  _Friend({this.id, this.userImg, this.userName});
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  List<_Friend> friends = [
    _Friend(
      id: "1",
      userImg:
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
      userName: "Aleksandra Romanowska",
    ),
    _Friend(
      id: "2",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/71234841_2546282945431303_4647513029292851200_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=BysYn0HX6UsAX8r23I8&_nc_ht=scontent-waw1-1.xx&oh=a9e74690edc8800402b331d5d1954c98&oe=5FF2575B",
      userName: "Paweł Kubala",
    ),
    _Friend(
      id: "3",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/54278936_1457227757741854_4938517215583404032_o.jpg?_nc_cat=107&ccb=2&_nc_sid=09cbfe&_nc_ohc=Gat38S_SZI8AX_STTfS&_nc_ht=scontent-waw1-1.xx&oh=3720e00c74643f09217613cc417060e5&oe=5FF2AC08",
      userName: "Michał Janik",
    ),
    _Friend(
      id: "4",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/74979486_2361985904061878_4597763555519889408_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=ZywGcq9zZmYAX_EhKGz&_nc_ht=scontent-waw1-1.xx&oh=47c0a3982df12e4f26904651ec665a1c&oe=5FF21720",
      userName: "Piotr Szymański",
    ),
    _Friend(
      id: "5",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/122430739_3440793809321027_6577478682371704533_o.jpg?_nc_cat=109&ccb=2&_nc_sid=09cbfe&_nc_ohc=xLa98r-Mef4AX_4hmGZ&_nc_ht=scontent-waw1-1.xx&oh=c0c2b0696f167e0665e8936febbba79b&oe=5FF7ED82",
      userName: "Maciej Lewandowicz",
    ),
    _Friend(
      id: "6",
      userImg:
          "https://vignette.wikia.nocookie.net/kamierowo/images/6/6e/Dzika_%C5%9Bwinia.png/revision/latest?cb=20171218204216&path-prefix=pl",
      userName: "Igor Cichecki",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildNavBar(
          context: context,
          routeName: FriendsListScreen.routeName,
          title: 'Znajomi'),
      body: ListView(
        children: [
          ...friends.map(
            (friend) => Friend(
              userImg: friend.userImg,
              userName: friend.userName,
            ),
          )
        ],
      ),
    );
  }
}
