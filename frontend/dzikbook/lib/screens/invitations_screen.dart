import 'package:dzikbook/providers/friends.dart';
import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/friend.dart';
import 'package:dzikbook/widgets/invitation.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvitationsScreen extends StatefulWidget {
  static final routeName = '/invitations-list';

  @override
  _InvitationsScreenState createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Friends>(context, listen: false).clearInvitations();
    final friendsProvider = Provider.of<Friends>(context, listen: false);
    friendsProvider.getFriendInvitations();
  }

  @override
  void dispose() {
    super.dispose();
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
          routeName: InvitationsScreen.routeName,
          title: 'Zaproszenia'),
      body: ListView(
        children: [
          ...friendsProvider.invitations.map(
            (user) => Invitation(
              invitationId: user.invitationId,
              userId: user.userId,
              userImg: user.userImg,
              userName: user.userName,
            ),
          )
        ],
      ),
    );
  }
}
