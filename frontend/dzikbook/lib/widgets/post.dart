import 'package:dzikbook/models/CommentModel.dart';
import 'package:dzikbook/widgets/comments_section.dart';
import 'package:flutter/material.dart';

import 'reactions_section.dart';

class Post extends StatelessWidget {
  final String id;
  final String userImg;
  final String userName;
  final String description;
  final String timeTaken;
  final String loadedImg;
  final List<CommentModel> comments;
  final int likes;
  Post({
    @required this.id,
    @required this.userName,
    @required this.description,
    @required this.userImg,
    @required this.timeTaken,
    this.loadedImg = "",
    this.comments,
    this.likes = 0,
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
                              alignment: Alignment.topCenter)),
                    ),
                    Text(
                      this.userName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                  ],
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
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[50],
            ),
          ),
          this.loadedImg == ""
              ? Container()
              : Image.network(
                  this.loadedImg,
                  loadingBuilder: (context, child, loadingProgress) {
                    return loadingProgress == null
                        ? child
                        : LinearProgressIndicator(
                            value: loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes,
                          );
                  },
                ),
          ReactionsSections(reactions: this.likes),
          CommentsSection(this.comments),
        ],
      ),
    );
  }
}
