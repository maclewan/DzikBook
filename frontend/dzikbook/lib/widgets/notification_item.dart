import 'package:dzikbook/providers/posts.dart';
import 'package:dzikbook/screens/friends_list_screen.dart';
import 'package:dzikbook/screens/invitations_screen.dart';
import 'package:dzikbook/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notifications.dart';

class NotificationItem extends StatelessWidget {
  final NotificationClass notification;

  NotificationItem({this.notification});

  @override
  Widget build(BuildContext context) {
    Icon icon;
    Function reactFunction;
    switch (notification.type) {
      case 'invitation_send':
        icon = Icon(Icons.person_add);
        reactFunction = () {
          Navigator.of(context).pushNamed(InvitationsScreen.routeName);
        };
        break;
      case 'invitation_accepted':
        icon = Icon(Icons.person);
        reactFunction = () {
          Navigator.of(context).pushNamed(FriendsListScreen.routeName);
        };
        break;
      case 'like':
        icon = Icon(Icons.thumb_up);
        reactFunction = () {
          if (notification.postId != null)
            Provider.of<Posts>(context, listen: false)
                .fetchSinglePost(postId: notification.postId)
                .then((r) {
              showDialog(
                  context: context,
                  builder: (_) => Dialog(
                        insetPadding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) =>
                              Post(
                            userId: r.userId,
                            hasReacted: r.hasReacted,
                            id: r.id,
                            userName: r.userName,
                            description: r.description,
                            userImg: r.userImg,
                            timeTaken: r.timeTaken,
                            hasImage: r.hasImage,
                            hasTraining: r.hasTraining,
                            likes: r.likes,
                            comments: r.comments,
                            loadedImg: r.hasImage ? r.loadedImg : null,
                            traning: r.hasTraining ? r.loadedTraining : null,
                          ),
                        ),
                      ));
            });
        };
        break;
      case 'comment':
        icon = Icon(Icons.comment);
        reactFunction = () {
          Provider.of<Posts>(context, listen: false)
              .fetchSinglePost(postId: notification.postId)
              .then((r) {
            showDialog(
                context: context,
                builder: (_) => Dialog(
                      insetPadding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) => Post(
                          userId: r.userId,
                          hasReacted: r.hasReacted,
                          id: r.id,
                          userName: r.userName,
                          description: r.description,
                          userImg: r.userImg,
                          timeTaken: r.timeTaken,
                          hasImage: r.hasImage,
                          hasTraining: r.hasTraining,
                          likes: r.likes,
                          comments: r.comments,
                          loadedImg: r.hasImage ? r.loadedImg : null,
                          traning: r.hasTraining ? r.loadedTraining : null,
                        ),
                      ),
                    ));
          });
        };
        break;
      default:
    }
    return ListTile(
      onTap: reactFunction,
      title: Text(notification.title),
      subtitle: Text(notification.body),
      leading: icon,
    );
  }
}
