import 'package:dzikbook/widgets/post.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static final routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Twój profil"),
        actions: [
          IconButton(icon: Icon(Icons.home), onPressed: null),
          IconButton(icon: Icon(Icons.food_bank), onPressed: null),
          IconButton(icon: Icon(Icons.fitness_center), onPressed: null),
        ],
      ),
      body: ListView(
        children: [
          Post(
            description:
                "Mój stary to fanatyk wędkarstwa, etc. etc. etc\n" * 10,
            id: '2',
            userImg:
                "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/119475981_375106286994751_5769617301736391369_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=XCLt0a0EbH0AX_ylteB&tp=1&oh=5c90fb584dd0b30371823a8eec8a65d5&oe=5FF754F7",
            userName: "Aleksandra",
            timeTaken: "36m",
          ),
          Post(
            description: "Mój stary to fanatyk wędkarstwa, etc. etc. etc\n" * 6,
            id: '2',
            userImg:
                "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/119475981_375106286994751_5769617301736391369_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=XCLt0a0EbH0AX_ylteB&tp=1&oh=5c90fb584dd0b30371823a8eec8a65d5&oe=5FF754F7",
            userName: "Aleksandra",
            timeTaken: "36m",
          ),
          Post(
            description: "Mój stary to fanatyk wędkarstwa, etc. etc. etc\n" * 3,
            id: '2',
            userImg:
                "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/119475981_375106286994751_5769617301736391369_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=XCLt0a0EbH0AX_ylteB&tp=1&oh=5c90fb584dd0b30371823a8eec8a65d5&oe=5FF754F7",
            userName: "Aleksandra",
            timeTaken: "36m",
          ),
          Post(
            description: "Mój stary to fanatyk wędkarstwa, etc. etc. etc\n" * 2,
            id: '2',
            userImg:
                "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/119475981_375106286994751_5769617301736391369_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=XCLt0a0EbH0AX_ylteB&tp=1&oh=5c90fb584dd0b30371823a8eec8a65d5&oe=5FF754F7",
            userName: "Aleksandra",
            timeTaken: "36m",
          ),
          Post(
            description: "Mój stary to fanatyk wędkarstwa, etc. etc. etc\n" * 5,
            id: '2',
            userImg:
                "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/119475981_375106286994751_5769617301736391369_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=XCLt0a0EbH0AX_ylteB&tp=1&oh=5c90fb584dd0b30371823a8eec8a65d5&oe=5FF754F7",
            userName: "Aleksandra",
            timeTaken: "36m",
          ),
          Post(
            description:
                "Mój stary to fanatyk wędkarstwa, etc. etc. etc\n" * 15,
            id: '2',
            userImg:
                "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/e35/p1080x1080/119475981_375106286994751_5769617301736391369_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=XCLt0a0EbH0AX_ylteB&tp=1&oh=5c90fb584dd0b30371823a8eec8a65d5&oe=5FF754F7",
            userName: "Aleksandra",
            timeTaken: "36m",
          ),
        ],
      ),
    );
  }
}
