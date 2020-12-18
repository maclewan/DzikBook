import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dzikbook/models/CommentModel.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'dart:async';
import 'package:dzikbook/models/config.dart';
import 'package:dzikbook/widgets/post.dart';
import 'package:flutter/widgets.dart';
import 'package:dzikbook/models/PostFetcher.dart';
import 'package:dzikbook/providers/workouts.dart';
import 'package:flutter/cupertino.dart';

class Credentials {
  String userName;
  String lastName;
  String userImg;
  Credentials(this.userName, this.lastName, this.userImg);
}

class Posts with ChangeNotifier {
  List<PostModel> _posts = [];

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

  void loadMore() {
    _isLoading = true;
    fetchMainPosts(10).then((List<PostModel> fetchedPosts) {
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

  Future<List<CommentModel>> fetchPostComments(int postId) async {
    final url = "$apiUrl/socials/comments/post/$postId/";
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
      for (var c in parsedList) {
        await getUserPhoto(c["author"].toString()).then((userPhoto) {
          CommentModel comment =
              new CommentModel(description: c["content"], imgSource: userPhoto);
          comments.add(comment);
        });
      }

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

  Future<bool> addComment(String postId, String comment) async {
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
        return false;
      }
      print("comment added for post $postId");
      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<PostModel>> fetchMainPosts(int counter) async {
    final url = "$apiUrl/wall/main?amount=$counter&offset=$postsCount";
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

      for (final r in parsedList) {
        await fetchPostComments(r["post_id"]).then((comments) async {
          await getCredentials(r["author"]).then((creds) {
            PostModel post = new PostModel(
                description: r["description"],
                id: r["post_id"].toString(),
                userImg: creds.userImg,
                userName: "${creds.userName} ${creds.lastName}",
                timeTaken: "15m",
                hasImage: r["photo"] != null ? true : false,
                hasTraining: false,
                comments: comments,
                loadedTraining: null,
                loadedImg: r["photo"] != null
                    ? Image.network('$apiUrl${r["photo"]}')
                    : null,
                likes: 0);
            posts.add(post);
            // print(posts.toString());
          });
        });
      }
      print('10 postów fetchowano przez ${stopwatch.elapsedMilliseconds}ms');
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

    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      print("Parsed User$userId info");

      final Map parsed = response.data;
      final imageResponse = await dio.get(imgUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      final imageUrl = apiUrl + imageResponse.data["photo"]["photo"];
      print("Parsed User$userId Image");
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
          comments: [],
          description: parsed["description"],
          id: parsed["post_id"].toString(),
          userImg: userPhoto,
          userName: username,
          timeTaken: "0",
          hasImage: parsed["photo"] == null ? false : true,
          hasTraining: false,
          loadedImg: parsed["photo"] == null
              ? null
              : Image.network('$apiUrl${parsed["photo"]}'),
          likes: 1);
      _posts.insert(0, post);
      postsCount++;
      notifyListeners();
    } catch (error) {
      throw HttpException("Operacja nie powiodła się!");
    }
  }

//   void addPost(postDescription, file, hasImg, hasTraining, training) {
//     _posts.insert(
//         0,
//         new PostModel(
//           hasImage: hasImg,
//           hasTraining: hasTraining,
//           loadedTraining: training,
//           description: postDescription,
//           id: "15",
//           timeTaken: "0m",
//           userName: mainUserName,
//           userImg: mainUserImage,
//           loadedImg: hasImg ? Image.file(file) : null,
//           likes: 0,
//           comments: [],
//         ));
//     notifyListeners();
//   }
}
