import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final String id;
  final String userImg;
  final String userName;
  final String description;
  final String timeTaken;
  Post(
      {this.id, this.userName, this.description, this.userImg, this.timeTaken});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.green,
          width: 3,
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
                            fit: BoxFit.fill,
                          )),
                    ),
                    Text(
                      this.userName,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
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
            child: Align(
              alignment: Alignment.center,
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }
}
