import 'package:flutter/material.dart';

class ReactionsSections extends StatefulWidget {
  ReactionsSections({Key key}) : super(key: key);

  @override
  _ReactionsSectionsState createState() => _ReactionsSectionsState();
}

class _ReactionsSectionsState extends State<ReactionsSections> {
  bool hasReacted = false;
  int reactionCount = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
                this.hasReacted ? Icons.favorite : Icons.favorite_outline,
                color: Colors.red[700]),
            onPressed: () {
              this.setState(() {
                if (this.hasReacted) {
                  this.reactionCount--;
                  this.hasReacted = false;
                } else {
                  this.reactionCount++;
                  this.hasReacted = true;
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${this.reactionCount}',
                  style: TextStyle(color: Colors.grey[400])),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red[500],
                    size: 15,
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
