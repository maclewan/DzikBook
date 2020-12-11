import 'dart:math';

import 'package:dzikbook/models/CommentModel.dart';
import 'package:dzikbook/models/dummyData.dart';
import 'package:dzikbook/widgets/add_comment.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CommentsSection extends StatefulWidget {
  final List<CommentModel> comments;

  CommentsSection(this.comments);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  void _addComment(String desc) {
    this.setState(() {
      this.widget.comments.add(
            new CommentModel(
              description: desc,
              imgSource: mainUserImage,
            ),
          );
      if (this.widget.comments.length != 1) {
        itemScrollController.scrollTo(
            index: this.widget.comments.length,
            duration: Duration(milliseconds: 500));
      }
    });
  }

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
            height: min(150, (this.widget.comments.length) * 50.0),
            child: ScrollablePositionedList.builder(
              itemCount: this.widget.comments.length,
              itemScrollController: this.itemScrollController,
              itemPositionsListener: this.itemPositionsListener,
              itemBuilder: (context, index) {
                if (index == -1) return null;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey[200],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(this.widget.comments[index].imgSource),
                        radius: 15),
                    title: Text(
                      this.widget.comments[index].description,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AddComment(
            key: Key("1asdsccdgfdbgvbfc"),
            addCommentHandler: _addComment,
          ),
        ],
      ),
    );
  }
}
