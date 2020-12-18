import 'package:dzikbook/providers/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ReactionsSections extends StatefulWidget {
  int likes;
  String postId;
  bool hasReacted;
  ReactionsSections(
      {@required this.postId, @required this.likes, @required this.hasReacted});

  @override
  _ReactionsSectionsState createState() => _ReactionsSectionsState();
}

class _ReactionsSectionsState extends State<ReactionsSections> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Provider.of<Posts>(context, listen: false)
                    .handleReaction(this.widget.postId, this.widget.hasReacted);
                this.setState(() {
                  if (this.widget.hasReacted) {
                    this.widget.likes--;
                    this.widget.hasReacted = false;
                  } else {
                    this.widget.likes++;
                    this.widget.hasReacted = true;
                  }
                });
              },
              child: SvgPicture.asset(
                'assets/images/${this.widget.hasReacted ? 'dzik_reaction.svg' : 'dzik_reaction_outlined.svg'}',
                width: 20,
                height: 20,
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(
          //       this.hasReacted ? Icons.favorite : Icons.favorite_outline,
          //       color: Colors.red[700]),
          //   onPressed: () {
          //     this.setState(() {
          //       if (this.hasReacted) {
          //         this.widget.likes--;
          //         this.hasReacted = false;
          //       } else {
          //         this.widget.likes++;
          //         this.hasReacted = true;
          //       }
          //     });
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${this.widget.likes}',
                  style: TextStyle(color: Colors.grey[400])),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: SvgPicture.asset(
                    'assets/images/dzik_reaction.svg',
                    width: 12,
                    height: 12,
                  ),
                ),
              ),
            ])),
          )
        ],
      ),
    );
  }
}
