import 'package:dzikbook/providers/friends.dart';
import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/friend.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsListScreen extends StatefulWidget {
  static final routeName = '/friends-list';

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  void initState() {
    final friendsProvider = Provider.of<Friends>(context, listen: false);
    friendsProvider.clearFriendList();
    friendsProvider.fetchFriendsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<Friends>(context, listen: true);
    return Scaffold(
      drawer: Drawer(
        child: DrawerBody(),
      ),
      appBar: buildNavBar(
          context: context,
          routeName: FriendsListScreen.routeName,
          title: 'Znajomi'),
      body: ListView(
        children: [
          ...friendsProvider.friends.map(
            (friend) => Friend(
              userImg: friend.userImg,
              userName: friend.userName,
              userId: friend.userId,
            ),
          )
        ],
      ),
    );
  }
}
