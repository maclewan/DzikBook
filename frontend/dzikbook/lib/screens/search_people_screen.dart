import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_svg/svg.dart';

class PersonsListScreen extends StatefulWidget {
  static final routeName = '/persons-list';

  @override
  _PersonsListScreenState createState() => _PersonsListScreenState();
}

class _Person {
  final String id, userImg, userName;

  _Person({this.id, this.userImg, this.userName});
}

class _PersonsListScreenState extends State<PersonsListScreen> {
  List<_Person> persons = [
    _Person(
      id: "1",
      userImg:
          "https://scontent-waw1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/p640x640/100932251_571933510393075_7245450438890519547_n.jpg?_nc_ht=scontent-waw1-1.cdninstagram.com&_nc_cat=107&_nc_ohc=qGVRrRvO0H4AX_Zrzea&tp=1&oh=71895bb42cf5ddc0b6be9d770cdd3ace&oe=5FF6CF63",
      userName: "Aleksandra Romanowska",
    ),
    _Person(
      id: "2",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/71234841_2546282945431303_4647513029292851200_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=BysYn0HX6UsAX8r23I8&_nc_ht=scontent-waw1-1.xx&oh=a9e74690edc8800402b331d5d1954c98&oe=5FF2575B",
      userName: "Paweł Kubala",
    ),
    _Person(
      id: "3",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/54278936_1457227757741854_4938517215583404032_o.jpg?_nc_cat=107&ccb=2&_nc_sid=09cbfe&_nc_ohc=Gat38S_SZI8AX_STTfS&_nc_ht=scontent-waw1-1.xx&oh=3720e00c74643f09217613cc417060e5&oe=5FF2AC08",
      userName: "Michał Janik",
    ),
    _Person(
      id: "4",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/74979486_2361985904061878_4597763555519889408_o.jpg?_nc_cat=104&ccb=2&_nc_sid=09cbfe&_nc_ohc=ZywGcq9zZmYAX_EhKGz&_nc_ht=scontent-waw1-1.xx&oh=47c0a3982df12e4f26904651ec665a1c&oe=5FF21720",
      userName: "Piotr Szymański",
    ),
    _Person(
      id: "5",
      userImg:
          "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/122430739_3440793809321027_6577478682371704533_o.jpg?_nc_cat=109&ccb=2&_nc_sid=09cbfe&_nc_ohc=xLa98r-Mef4AX_4hmGZ&_nc_ht=scontent-waw1-1.xx&oh=c0c2b0696f167e0665e8936febbba79b&oe=5FF7ED82",
      userName: "Maciej Lewandowicz",
    ),
    _Person(
      id: "6",
      userImg:
          "https://vignette.wikia.nocookie.net/kamierowo/images/6/6e/Dzika_%C5%9Bwinia.png/revision/latest?cb=20171218204216&path-prefix=pl",
      userName: "Igor Cichecki",
    ),
  ];

  SearchBar searchBar;
  AppBar buildAppBar(BuildContext context) {
    return buildNavBar(
        context: context,
        title: "Wyszukaj",
        routeName: PersonsListScreen.routeName,
        children: [searchBar.getSearchAction(context)]);
  }

  _PersonsListScreenState() {
    searchBar = new SearchBar(
        hintText: "Wyszukaj użytkownika Dzikbooka",
        inBar: false,
        setState: setState,
        onSubmitted: (s) {
          setState(() {
            persons.removeWhere(
                (p) => !p.userName.toLowerCase().contains(s.toLowerCase()));
          });
        },
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: persons.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/dzik.svg',
                  width: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40),
                  child: Text(
                    "Wpisz imię i nazwisko użytkownika, którego chcesz znaleźć na Dzikbooku",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ))
          : ListView(
              children: [
                ...persons.map(
                  (person) => ListTile(
                    title: Text(person.userName),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(person.userImg),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: FlatButton(
                                            minWidth: double.infinity,
                                            onPressed: () {},
                                            child: Text("Dodaj do znajomych")),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                            minWidth: double.infinity,
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserProfileScreen(
                                                            userImage:
                                                                person.userImg,
                                                            userName:
                                                                person.userName,
                                                          )));
                                            },
                                            child: Text("Pokaż profil")),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                    dense: true,
                  ),
                )
              ],
            ),
    );
  }
}
