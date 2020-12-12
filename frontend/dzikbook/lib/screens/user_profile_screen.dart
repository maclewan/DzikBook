import 'package:dzikbook/models/PostFetcher.dart';
import 'package:dzikbook/screens/calendar_plans_screen.dart';
import 'package:dzikbook/screens/diet_list_screen.dart';
import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:flutter/material.dart';

import 'package:dzikbook/widgets/post.dart';
import '../models/dummyData.dart';

class UserProfileScreen extends StatefulWidget {
  static final routeName = '/user-profile';
  final String userName;
  final String userImage;
  UserProfileScreen(
      {this.userImage = mainUserImage, this.userName = mainUserName});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<PostModel> _posts = [];

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

  PostFetcher _postFetcher;

  bool _isLoading = true;
  bool _hasMore = true;

  void _loadMore() {
    if (mounted) {
      _isLoading = true;
      _postFetcher.fetchPostsList(10).then((List<PostModel> fetchedPosts) {
        if (fetchedPosts.isEmpty) {
          setState(() {
            _isLoading = false;
            _hasMore = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _posts.addAll(fetchedPosts);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _posts.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profil"),
          actions: [
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () => {
                      Navigator.of(context)
                          .pushNamed(CalendarPlansScreen.routeName)
                    }),
            IconButton(
                icon: Icon(Icons.food_bank),
                onPressed: () => {
                      Navigator.of(context).pushNamed(DietListScreen.routeName,
                          arguments: false),
                    }),
            IconButton(
                icon: Icon(Icons.fitness_center),
                onPressed: () => {
                      Navigator.of(context).pushNamed(
                          WorkoutListScreen.routeName,
                          arguments: false)
                    }),
          ],
        ),
        body: ListView.builder(
          itemCount: _hasMore ? _posts.length + 1 : _posts.length,
          itemBuilder: (BuildContext context, int index) {
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
              description: _posts[index].description,
              id: index.toString(),
              timeTaken: _posts[index].timeTaken,
              userName: _posts[index].userName,
              comments: _posts[index].comments,
              likes: _posts[index].likes,
              hasImage: _posts[index].hasImage,
              userImg: _posts[index].userImg,
              loadedImg:
                  _posts[index].hasImage ? _posts[index].loadedImg : null,
            );
          },
        ));
  }
}
