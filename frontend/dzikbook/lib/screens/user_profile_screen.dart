import 'package:dzikbook/models/PostFetcher.dart';
import 'package:dzikbook/providers/posts.dart';
import 'package:dzikbook/providers/user_data.dart';
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
  const UserProfileScreen(
      {this.userImage = mainUserImage,
      this.userName = mainUserName,
      this.rootUser = true,
      this.friend = false,
      this.id});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Posts>(context, listen: false).restart();
    Provider.of<Posts>(context, listen: false).loadMore(type: 1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var postsProvider = Provider.of<Posts>(context, listen: true);
    return Scaffold(
        appBar: buildNavBar(
            context: context,
            routeName: UserProfileScreen.routeName,
            title: 'Profil'),
        body: ListView.builder(
          itemCount: postsProvider.hasMore
              ? postsProvider.wallPostsCount + 1
              : postsProvider.wallPostsCount,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return UserProfileInfo(
                userImg: this.widget.userImage,
                userName: this.widget.userName,
                rootUser: this.widget.rootUser,
                isFriend: this.widget.friend,
              );
            if (index >= postsProvider.wallPostsCount) {
              if (!postsProvider.isLoading) {
                postsProvider.loadMore(type: 1);
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
              id: index.toString(),
              timeTaken: postsProvider.wallPosts[index - 1].timeTaken,
              userName: postsProvider.wallPosts[index - 1].userName,
              comments: postsProvider.wallPosts[index - 1].comments,
              likes: postsProvider.wallPosts[index - 1].likes,
              hasImage: postsProvider.wallPosts[index - 1].hasImage,
              userImg: postsProvider.wallPosts[index - 1].userImg,
              loadedImg: postsProvider.wallPosts[index - 1].hasImage
                  ? postsProvider.wallPosts[index - 1].loadedImg
                  : null,
              hasTraining: false,
              hasReacted: postsProvider.wallPosts[index - 1].hasReacted,
              userId: this.widget.id,
            );
          },
        ));
  }
}
