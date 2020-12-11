import 'package:flutter/material.dart';

class ReactionsSections extends StatefulWidget {
  int likes;
  ReactionsSections({this.likes});

  @override
  _ReactionsSectionsState createState() => _ReactionsSectionsState();
}

class _ReactionsSectionsState extends State<ReactionsSections> {
  bool hasReacted = false;

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
                  this.widget.likes--;
                  this.hasReacted = false;
                } else {
                  this.widget.likes++;
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
                  text: '${this.widget.likes}',
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
