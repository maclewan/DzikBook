import 'package:dzikbook/models/CommentModel.dart';
import 'package:dzikbook/widgets/add_comment.dart';
import 'package:flutter/material.dart';

class CommentsSection extends StatefulWidget {
  final List<CommentModel> comments;
  CommentsSection(this.comments);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150,
            child: ListView(
              children: [
                //TODO: lazy loading for these
                ...this.widget.comments.map(
                      (comment) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey[200],
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(comment.imgSource),
                              radius: 15),
                          title: Text(
                            comment.description,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          AddComment(
            key: Key("1asdsccdgfdbgvbfc"),
          ),
        ],
      ),
    );
  }
}
