import 'package:dzikbook/widgets/add_post.dart';
import 'package:dzikbook/widgets/post.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static final routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _Post {
  final String description;
  final String id, userImg, userName, timeTaken;

  _Post(
      {this.description, this.id, this.userImg, this.userName, this.timeTaken});
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<_Post> posts = [
    _Post(
      description: "Cześć i czołem, sprzedam opla!",
      id: '2',
      userImg:
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
      userName: "Aleksandra",
      timeTaken: "36m",
    ),
    _Post(
      description: "Kupię 3 Ople!\n" * 3,
      id: '3',
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/71234841_2546282945431303_4647513029292851200_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=BysYn0HX6UsAX8r23I8&_nc_ht=scontent-waw1-1.xx&oh=a9e74690edc8800402b331d5d1954c98&oe=5FF2575B",
      userName: "Paweł",
      timeTaken: "1h15m",
    ),
    _Post(
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
    _Post(
      description: "Jem lody długo, etc. etc. etc\n" * 2,
      id: '5',
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/74979486_2361985904061878_4597763555519889408_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=ZywGcq9zZmYAX_EhKGz&_nc_ht=scontent-waw1-1.xx&oh=47c0a3982df12e4f26904651ec665a1c&oe=5FF21720",
      userName: "Piotr",
      timeTaken: "36m",
    ),
    _Post(
      description: "Mój tato to fanatyk wędkarstwa, etc. etc. etc\n" * 2,
      id: '5',
      userImg:
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
      userName: "Aleksandra",
      timeTaken: "36m",
    ),
    _Post(
      description: "Mój tato to fanatyk wędkarstwa, etc. etc. etc\n" * 5,
      id: '6',
      userImg:
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
      userName: "Aleksandra",
      timeTaken: "36m",
    ),
    _Post(
      description: "Mój tato to fanatyk wędkarstwa, etc. etc. etc\n" * 15,
      id: '7',
      userImg:
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
      userName: "Aleksandra",
      timeTaken: "55m",
    ),
  ];

  void _addPost(postDescription) {
    setState(() {
      posts.insert(
        0,
        new _Post(
            description: postDescription,
            id: "15",
            timeTaken: "0m",
            userName: "Aleksandra",
            userImg:
                "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/s640x640/102961878_261268128624182_7495919051351016811_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=102&_nc_ohc=guXVxhmpNwAAX99UoVb&tp=1&oh=fa49d2ba06d4607807963b90f693449c&oe=5FF5F2E8"),
      );
    });
  }

  @override
  void initState() {
    super.initState();
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
      body: ListView(
        children: [
          AddPost(_addPost,
              "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/s640x640/102961878_261268128624182_7495919051351016811_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=102&_nc_ohc=guXVxhmpNwAAX99UoVb&tp=1&oh=fa49d2ba06d4607807963b90f693449c&oe=5FF5F2E8"),
          ...posts
              .map((post) => Post(
                    id: post.id,
                    description: post.description,
                    timeTaken: post.timeTaken,
                    userImg: post.userImg,
                    userName: post.userName,
                  ))
              .toList()
        ].toList(),
      ),
    );
  }
}
