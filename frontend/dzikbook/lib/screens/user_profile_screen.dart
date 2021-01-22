import 'package:dzikbook/models/PostFetcher.dart';
import 'package:dzikbook/providers/posts.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:dzikbook/widgets/user_profile_info.dart';
import 'package:flutter/material.dart';

import 'package:dzikbook/widgets/post.dart';
import 'package:provider/provider.dart';
import '../models/dummyData.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/user-profile';
  final String userName;
  final String userImage;
  final bool rootUser;
  final bool friend;
  final String id;
  final int postsCount;
  final int dietsCount;
  final int trainingsCount;
  const UserProfileScreen(
      {this.userImage = mainUserImage,
      this.userName = mainUserName,
      this.rootUser = true,
      this.friend = false,
      @required this.postsCount,
      @required this.dietsCount,
      @required this.trainingsCount,
      @required this.id});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Posts>(context, listen: false).restart();
    if (this.widget.rootUser) {
      Provider.of<Posts>(context, listen: false).loadMore(type: 1);
    } else
      Provider.of<Posts>(context, listen: false)
          .loadMore(type: 2, userId: this.widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var postsProvider = Provider.of<Posts>(context, listen: true);
    return Scaffold(
        drawer: Drawer(
          child: DrawerBody(),
        ),
        appBar: buildNavBar(
            context: context,
            routeName: UserProfileScreen.routeName,
            title: 'Profil'),
        body: ListView.builder(
          itemCount: postsProvider.hasMore
              ? postsProvider.wallPostsCount + 2
              : postsProvider.wallPostsCount + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return UserProfileInfo(
                userId: this.widget.id,
                postsCount: this.widget.postsCount,
                trainingsCount: this.widget.trainingsCount,
                dietsCount: this.widget.dietsCount,
                userImg: this.widget.userImage,
                userName: this.widget.userName,
                rootUser: this.widget.rootUser,
                isFriend: this.widget.friend,
              );
            if (index >= postsProvider.wallPostsCount + 1) {
              if (!postsProvider.isLoading) {
                postsProvider.loadMore(
                    type: this.widget.rootUser ? 1 : 2, userId: this.widget.id);
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 24,
                    width: 24,
                  ),
                ),
              );
            }

            return Post(
              clickable: false,
              description: postsProvider.wallPosts[index - 1].description,
              id: postsProvider.wallPosts[index - 1].id,
              timeTaken: postsProvider.wallPosts[index - 1].timeTaken,
              userName: postsProvider.wallPosts[index - 1].userName,
              comments: postsProvider.wallPosts[index - 1].comments,
              likes: postsProvider.wallPosts[index - 1].likes,
              hasImage: postsProvider.wallPosts[index - 1].hasImage,
              userImg: postsProvider.wallPosts[index - 1].userImg,
              loadedImg: postsProvider.wallPosts[index - 1].hasImage
                  ? postsProvider.wallPosts[index - 1].loadedImg
                  : null,
              hasTraining: postsProvider.wallPosts[index - 1].hasTraining,
              traning: postsProvider.wallPosts[index - 1].hasTraining
                  ? postsProvider.wallPosts[index - 1].loadedTraining
                  : null,
              hasReacted: postsProvider.wallPosts[index - 1].hasReacted,
              userId: this.widget.id,
            );
          },
        ));
  }
}
