import 'package:dzikbook/models/PostFetcher.dart';
import 'package:flutter/material.dart';

import 'package:dzikbook/widgets/add_post.dart';
import 'package:dzikbook/widgets/post.dart';
import '../models/dummyData.dart';

class ProfileScreen extends StatefulWidget {
  static final routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<PostModel> _posts = [
    PostModel(
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

  void _addPost(postDescription, _file, hasImg) {
    setState(() {
      _posts.insert(
          0,
          new PostModel(
            hasImage: hasImg,
            description: postDescription,
            id: "15",
            timeTaken: "0m",
            userName: mainUserName,
            userImg: mainUserImage,
            loadedImg: hasImg ? Image.file(_file) : null,
            likes: 0,
            comments: [],
          ));
    });
  }

  bool _isLoading = true;
  bool _hasMore = true;

  void _loadMore() {
    _isLoading = true;
    _postFetcher.fetchPostsList(10).then((List<PostModel> fetchedPosts) {
      if (fetchedPosts.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _posts.addAll(fetchedPosts);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Twój profil"),
          actions: [
            IconButton(icon: Icon(Icons.home), onPressed: () => {}),
            IconButton(icon: Icon(Icons.food_bank), onPressed: () => {}),
            IconButton(icon: Icon(Icons.fitness_center), onPressed: () => {}),
          ],
        ),
        body: ListView.builder(
          itemCount: _hasMore ? _posts.length + 1 : _posts.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return AddPost(_addPost, mainUserImage);
            if (index >= _posts.length) {
              if (!_isLoading) {
                _loadMore();
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 24,
                    width: 24,
                  ),
                ),
              );
            }
            return Post(
              description: _posts[index - 1].description,
              id: index.toString(),
              timeTaken: _posts[index - 1].timeTaken,
              userName: _posts[index - 1].userName,
              comments: _posts[index - 1].comments,
              likes: _posts[index - 1].likes,
              hasImage: _posts[index - 1].hasImage,
              userImg: _posts[index - 1].userImg,
              loadedImg: _posts[index - 1].hasImage
                  ? _posts[index - 1].loadedImg
                  : null,
            );
          },
        ));
  }
}
