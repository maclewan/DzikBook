import 'package:dzikbook/models/PostFetcher.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:dzikbook/widgets/user_profile_info.dart';
import 'package:flutter/material.dart';

import 'package:dzikbook/widgets/post.dart';
import '../models/dummyData.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = '/user-profile';
  final String userName;
  final String userImage;
  final bool rootUser;
  final bool friend;
  const UserProfileScreen(
      {this.userImage = mainUserImage,
      this.userName = mainUserName,
      this.rootUser = true,
      this.friend = false});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<PostModel> _posts = [];
  PostFetcher _postFetcher;
  bool _isLoading = true;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _postFetcher = PostFetcher(
        specificUser: true,
        specificUserImageUrl: this.widget.userImage,
        specificUserName: this.widget.userName);
    _hasMore = true;
    _loadMore();
  }

  void _loadMore() {
    _isLoading = true;
    _postFetcher.fetchPostsList(10).then((List<PostModel> fetchedPosts) {
      if (fetchedPosts.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasMore = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _posts.addAll(fetchedPosts);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _posts.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildNavBar(
            context: context,
            routeName: UserProfileScreen.routeName,
            title: 'Profil'),
        body: ListView.builder(
          itemCount: _hasMore ? _posts.length + 1 : _posts.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return UserProfileInfo(
                userImg: this.widget.userImage,
                userName: this.widget.userName,
                rootUser: this.widget.rootUser,
                isFriend: this.widget.friend,
              );
            if (index >= _posts.length) {
              if (!_isLoading) {
                _loadMore();
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
              description: _posts[index - 1].description,
              id: index.toString(),
              timeTaken: _posts[index - 1].timeTaken,
              userName: _posts[index - 1].userName,
              comments: _posts[index - 1].comments,
              likes: _posts[index - 1].likes,
              hasImage: _posts[index - 1].hasImage,
              userImg: _posts[index - 1].userImg,
              loadedImg: _posts[index - 1].hasImage
                  ? _posts[index - 1].loadedImg
                  : null,
            );
          },
        ));
  }
}
