import 'dart:convert' show utf8, json;
import 'dart:io';
import 'dart:math';
import 'package:dzikbook/providers/workouts.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'CommentModel.dart';

class PostModel {
  final String userId;
  final int secondsTaken;
  final String description;
  final String id, userImg, userName, timeTaken;
  final Image loadedImg;
  final List<CommentModel> comments;
  final int likes;
  final bool hasImage;
  final bool hasTraining;
  final bool hasReacted;
  final Workout loadedTraining;

  PostModel(
      {@required this.userId,
      @required this.description,
      @required this.id,
      @required this.userImg,
      @required this.userName,
      @required this.timeTaken,
      @required this.hasImage,
      @required this.hasTraining,
      @required this.hasReacted,
      this.loadedImg,
      this.comments,
      this.loadedTraining,
      @required this.secondsTaken,
      @required this.likes});
}
