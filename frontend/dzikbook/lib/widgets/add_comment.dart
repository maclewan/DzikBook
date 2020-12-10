import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  final void Function(String) addCommentHandler;
  AddComment({Key key, @required this.addCommentHandler}) : super(key: key);

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

//TODO: strange text behaviour during scrolling
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
      margin: EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 5),
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[150],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 42.0,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                  child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    child: SizedBox(
                      child: new TextField(
                        controller: myController,
                        maxLines: 5,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          hintText: 'Dodaj komentarz',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
              child: IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    if (myController.text.isNotEmpty)
                      this.widget.addCommentHandler(myController.text);
                    myController.clear();
                  }))
        ],
      ),
    );
  }
}
