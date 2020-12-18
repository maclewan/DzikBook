import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dzikbook/models/CommentModel.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'dart:async';
import 'package:dzikbook/models/config.dart';
import 'package:flutter/widgets.dart';
import 'package:dzikbook/models/PostFetcher.dart';
import 'package:flutter/cupertino.dart';

class Credentials {
  String userName;
  String lastName;
  String userImg;
  Credentials(this.userName, this.lastName, this.userImg);
}

class Posts with ChangeNotifier {
  String userId;
  List<PostModel> _posts = [];
  static String formatDuration(Duration d) {
    var seconds = d.inSeconds.abs();
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }

  String token;
  String refreshToken;
  bool _isLoading = true;
  bool _hasMore = true;
  Dio dio = new Dio();
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  int postsCount = 0;

  List<PostModel> get wallPosts => _posts;

  int get wallPostsCount => _posts.length;

  void loadMore({int type, int userId = 0}) {
    _isLoading = true;
    fetchMainPosts(counter: 10, type: type, userId: userId)
        .then((List<PostModel> fetchedPosts) {
      if (fetchedPosts.isEmpty) {
        _isLoading = false;
        _hasMore = false;
      } else {
        _isLoading = false;
        _posts.addAll(fetchedPosts);
      }
      notifyListeners();
    });
  }

  void restart() {
    this._posts.clear();
    this._hasMore = true;
    this._isLoading = true;
    this.postsCount = 0;
  }

  Future<List> getPostReactions(int postId) async {
    final url = "$apiUrl/socials/reactions/$postId";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      final List r = response.data;
      List<int> reactions = [for (final i in r) i["user_id"]];
      return reactions;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<List<CommentModel>> fetchPostComments(int postId) async {
    final url = "$apiUrl/socials/comments/post/$postId/";
    Stopwatch stopwatch = Stopwatch()..start();
    List<CommentModel> comments = [];
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        return [];
      }
      final List parsedList = response.data;
      await Future.wait([
        for (var c in parsedList)
          getUserPhoto(c["author"].toString()).then((userPhoto) {
            CommentModel comment = new CommentModel(
                description: c["content"],
                imgSource: userPhoto,
                commentId: c["comment_id"]);
            comments.add(comment);
          })
      ]);
      print(
          "Fetchowanie ${comments.length} komentarzy dla posta $postId trwało ${stopwatch.elapsedMilliseconds}ms");
      comments.sort((a, b) {
        int aId = a.commentId;
        int bId = b.commentId;
        return aId.compareTo(bId);
      });
      return comments;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<String> getUserPhoto(String userId) async {
    final imgUrl = "$apiUrl/media/profile/user/$userId/";

    try {
      final imageResponse = await dio.get(imgUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      final imageUrl = apiUrl + imageResponse.data["photo"]["photo"];
      return imageUrl;
    } catch (error) {
      print(error);
      return defaultPhotoUrl;
    }
  }

  Future<int> addComment(String postId, String comment) async {
    final url = "$apiUrl/socials/comments/post/$postId/";
    Map<String, dynamic> body = {
      'content': comment,
    };
    FormData formData = new FormData.fromMap(body);

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
          },
        ),
        data: formData,
      );
      if (response.statusCode >= 400) {
        return null;
      }
      print("comment added for post $postId");
      return response.data["comment_id"];
    } catch (error) {
      return null;
    }
  }

  Future<bool> handleReaction(String postId, bool hasReacted) async {
    final url = "$apiUrl/socials/reactions/$postId/";
    if (hasReacted) {
      try {
        final response = await dio.delete(url,
            options: Options(headers: {
              "Authorization": "Bearer " + token,
            }));
        print(response);

        return true;
      } catch (error) {
        print(error);
        return false;
      }
    } else {
      try {
        final response = await dio.post(url,
            options: Options(headers: {
              "Authorization": "Bearer " + token,
            }));
        print(response);
        return true;
      } catch (error) {
        print(error);
        return false;
      }
    }
  }

  Future<List<PostModel>> fetchMainPosts(
      {int counter, int type, int userId = 0}) async {
    var url;
    if (type == 0)
      url = "$apiUrl/wall/main?amount=$counter&offset=$postsCount";
    else if (type == 1) url = "$apiUrl/wall?amount=$counter&offset=$postsCount";
    postsCount += counter;
    List<PostModel> posts = [];
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      final List parsedList = response.data;
      Stopwatch stopwatch = new Stopwatch()..start();
      await Future.wait([
        for (final r in parsedList)
          fetchPostComments(r["post_id"]).then((comments) async {
            await getPostReactions(r["post_id"]).then((reactions) async {
              await getCredentials(r["author"]).then((creds) {
                DateTime now = (DateTime.now().add(Duration(hours: 6)));
                DateTime old = (DateTime.parse(r["timestamp"]));
                // print(r["timestamp"]);
                Duration timeDuration = now.difference(old);
                timeDuration -= Duration(hours: 5);
                print(now);
                print(old);
                print("_" * 10);
                String time = formatDuration(timeDuration);

                int secondsTaken = timeDuration.inSeconds;
                PostModel post = new PostModel(
                    userId: r["author"].toString(),
                    hasReacted: reactions.contains(int.parse(this.userId)),
                    secondsTaken: secondsTaken,
                    description: r["description"],
                    id: r["post_id"].toString(),
                    userImg: creds.userImg,
                    userName: "${creds.userName} ${creds.lastName}",
                    timeTaken: time,
                    hasImage: r["photo"] != null ? true : false,
                    hasTraining: false,
                    comments: comments,
                    loadedTraining: null,
                    loadedImg: r["photo"] != null
                        ? Image.network('$apiUrl${r["photo"]}')
                        : null,
                    likes: reactions.length);
                posts.add(post);
                // print(posts.toString());
              });
            });
          })
      ]);

      print('10 postów fetchowano przez ${stopwatch.elapsedMilliseconds}ms');
      posts.sort((a, b) {
        var aSeconds = a.secondsTaken;
        var bSeconds = b.secondsTaken;
        return aSeconds.compareTo(bSeconds);
      });
      return posts;
      // final Map parsedImg = json.decode(imageResponse.data);
      // print(parsedImg);
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<Credentials> getCredentials(int userId) async {
    final url = "$apiUrl/users/data/$userId/";
    final imgUrl = "$apiUrl/media/profile/user/$userId/";
    Map parsed;
    String imageUrl;
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      parsed = response.data;
      final imageResponse = await dio.get(imgUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      imageUrl = apiUrl + imageResponse.data["photo"]["photo"];
      return Credentials(parsed["first_name"], parsed["last_name"], imageUrl);
    } catch (error) {
      throw HttpException("Nie ma fotki!");
    }
  }

  Future<void> addPost(postDescription, file, hasImg, hasTraining, training,
      username, userPhoto) async {
    final url = "$apiUrl/wall/post/";
    Map<String, dynamic> body = {
      'description': postDescription,
      'additional_data': json.encode(training),
      'type': hasImg
          ? 'media'
          : hasTraining
              ? 'training'
              : 'text',
    };
    FormData formData = new FormData.fromMap(body);
    if (hasImg)
      formData.files.add(MapEntry(
        "photo",
        await MultipartFile.fromFile(file.path, filename: file.path),
      ));
    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
          },
        ),
        data: formData,
      );

      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      final Map parsed = response.data;
      PostModel post = PostModel(
          hasReacted: false,
          secondsTaken: 0,
          userId: this.userId,
          comments: [],
          description: parsed["description"],
          id: parsed["post_id"].toString(),
          userImg: userPhoto,
          userName: username,
          timeTaken: "0s",
          hasImage: parsed["photo"] == null ? false : true,
          hasTraining: false,
          loadedImg: parsed["photo"] == null
              ? null
              : Image.network('$apiUrl${parsed["photo"]}'),
          likes: 0);
      _posts.insert(0, post);
      postsCount++;
      notifyListeners();
    } catch (error) {
      throw HttpException("Operacja nie powiodła się!");
    }
  }
}
