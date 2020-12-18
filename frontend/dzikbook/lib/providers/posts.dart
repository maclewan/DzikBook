import 'dart:convert';
import 'package:dio/dio.dart';
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
  Credentials(this.userName, this.lastName);
}

class Posts with ChangeNotifier {
  List<PostModel> _posts = [
    PostModel(
        hasTraining: false,
        hasImage: true,
        comments: [],
        description: "Cześć i czołem, Oto zdjęcie w 4k!",
        id: '2',
        likes: 169,
        userImg:
            "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
        userName: "Aleksandra",
        timeTaken: "36m",
        loadedImg: Image.network(
          "https://external-preview.redd.it/GOkP8onbuyjGmN9Rc8Que5mw21CdSw6OuXpAKUuE6-4.jpg?auto=webp&s=2bc0e522d1f2fa887333286d557466b2be00fa5e",
        )),
    PostModel(
        hasTraining: false,
        hasImage: true,
        comments: [],
        description: "O M G  ale super fotka",
        id: '3',
        likes: 11,
        userImg:
            "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/71234841_2546282945431303_4647513029292851200_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=BysYn0HX6UsAX8r23I8&_nc_ht=scontent-waw1-1.xx&oh=a9e74690edc8800402b331d5d1954c98&oe=5FF2575B",
        userName: "Paweł",
        timeTaken: "1h15m",
        loadedImg: Image.network(
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/67877813_382156209038925_8513675155840603087_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=109&_nc_ohc=u-LKXxK-arsAX9rJagO&tp=1&oh=1a5c2d444061b2bf8a3ca1b037167de1&oe=5FFA1A58",
        )),
    PostModel(
      hasTraining: false,
      hasImage: false,
      likes: 420,
      comments: [],
      description:
          """To szukanie tej pracy teraz mając jedynie 1,5 roku w starej utrzymaniowce jest ciężkie. Już dwa razy miałem, że bardzo dobrze mi poszła część techniczna, ale dostałem informację, że wzięli po prostu kogoś kto ma więcej lat i tyle. C++ here i najgorsze to, że nie mogę zmienić miasta bo inaczej byłoby easy.
                Czuje że już się tak wypaliłem po toksycznym poprzednim korpo, że nawet jakbym coś znalazł to bym się szczególnie nie cieszył.
                """,
      id: '4',
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/54278936_1457227757741854_4938517215583404032_o.jpg?_nc_cat=107&ccb=2&_nc_sid=09cbfe&_nc_ohc=Gat38S_SZI8AX_STTfS&_nc_ht=scontent-waw1-1.xx&oh=3720e00c74643f09217613cc417060e5&oe=5FF2AC08",
      userName: "Michał ",
      timeTaken: "1d",
    ),
    PostModel(
      hasTraining: true,
      loadedTraining: Workout(
          name: "Trening u super długiej nazwie byczq",
          workoutLength: 60,
          exercises: [
            Exercise(
                id: "1",
                name: "klatka płaska",
                series: 4,
                reps: 8,
                breakTime: 0),
            Exercise(
                id: "2",
                name: "klatka skośna",
                series: 4,
                reps: 15,
                breakTime: 0),
            Exercise(
                id: "3",
                name: "I TAKI POWINIEN BYĆ DUMMY DATA BYCZQ",
                series: 4,
                reps: 8,
                breakTime: 15),
            Exercise(
                id: "4", name: "Rozpiętki", series: 4, reps: 8, breakTime: 15),
          ]),
      hasImage: false,
      likes: 15,
      comments: [],
      description: "Jem lody długo, etc. etc. etc\n" * 2,
      id: '5',
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/74979486_2361985904061878_4597763555519889408_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=ZywGcq9zZmYAX_EhKGz&_nc_ht=scontent-waw1-1.xx&oh=47c0a3982df12e4f26904651ec665a1c&oe=5FF21720",
      userName: "Piotr",
      timeTaken: "36m",
    ),
    PostModel(
      hasTraining: false,
      hasImage: false,
      likes: 10,
      comments: [],
      description: "Mój tato to fanatyk wędkarstwa, etc. etc. etc\n" * 2,
      id: '5',
      userImg:
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
      userName: "Aleksandra",
      timeTaken: "36m",
    ),
  ];

  final _postFetcher = PostFetcher();
  String token;
  String refreshToken;
  bool _isLoading = false;
  bool _hasMore = true;
  Dio dio = new Dio();
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  List<PostModel> get wallPosts => _posts;

  int get wallPostsCount => _posts.length;

  void loadMore() {
    _isLoading = true;
    _postFetcher.fetchPostsList(10).then((List<PostModel> fetchedPosts) {
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

  Future<Credentials> getCredentials(int userId) async {
    final url = "$apiUrl/users/data/$userId/";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }

      final Map parsed = response.data;
      return Credentials(parsed["first_name"], parsed["last_name"]);
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
      print(post.toString());
      _posts.insert(0, post);
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
