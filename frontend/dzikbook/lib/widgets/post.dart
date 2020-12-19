import 'package:dzikbook/models/CommentModel.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/providers/workouts.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:dzikbook/widgets/comments_section.dart';
import 'package:dzikbook/widgets/workout_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'reactions_section.dart';

class Post extends StatelessWidget {
  final String id;
  final String userId;
  final String userImg;
  final String userName;
  final String description;
  final String timeTaken;
  final Image loadedImg;
  final bool hasImage;
  final bool hasTraining;
  final bool hasReacted;
  final Workout traning;
  final List<CommentModel> comments;
  final int likes;
  final bool clickable;
  const Post({
    @required this.userId,
    @required this.hasReacted,
    @required this.id,
    @required this.userName,
    @required this.description,
    @required this.userImg,
    @required this.timeTaken,
    @required this.hasImage,
    @required this.hasTraining,
    this.traning,
    this.loadedImg,
    this.comments,
    this.clickable = true,
    @required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.green,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (this.clickable) {
                      final userDataProvider =
                          Provider.of<UserData>(context, listen: false);
                      if (this.userId == userDataProvider.id) {
                        userDataProvider
                            .getUserPostsCount(this.userId)
                            .then((List<int> posts) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                  postsCount: posts[0],
                                  trainingsCount: posts[1],
                                  dietsCount: posts[2],
                                  id: userDataProvider.id,
                                  friend: false,
                                  rootUser: true,
                                  userName: userDataProvider.name +
                                      " " +
                                      userDataProvider.lastName,
                                  userImage: userDataProvider.imageUrl,
                                ),
                              ));
                        });
                      } else {
                        userDataProvider
                            .getAnotherUserData(this.userId)
                            .then((data) {
                          print(data);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfileScreen(
                                        postsCount: data.posts[0],
                                        trainingsCount: data.posts[1],
                                        dietsCount: data.posts[2],
                                        id: this.userId,
                                        friend: data.isFriend,
                                        rootUser: false,
                                        userImage: data.image,
                                        userName: data.name,
                                      )));
                        });
                      }
                    }
                  },
                  child: Row(
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
                                alignment: Alignment.topCenter)),
                      ),
                      Text(
                        this.userName,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                    Text(
                      this.timeTaken,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, left: 15, bottom: 10, right: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                description,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  letterSpacing: .2,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
          ),
          this.hasImage == false
              ? Container()
              : Image(
                  image: this.loadedImg.image,
                  loadingBuilder: (context, child, loadingProgress) {
                    return loadingProgress == null
                        ? child
                        : LinearProgressIndicator(
                            value: loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes,
                          );
                  },
                ),
          if (this.hasTraining) WorkoutPost(workout: this.traning),
          ReactionsSections(
            likes: this.likes,
            postId: this.id,
            hasReacted: this.hasReacted,
          ),
          CommentsSection(this.comments, this.id),
        ],
      ),
    );
  }
}
