import 'package:dzikbook/providers/search_people.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';

class PersonsListScreen extends StatefulWidget {
  static final routeName = '/persons-list';

  @override
  _PersonsListScreenState createState() => _PersonsListScreenState();
}

class _PersonsListScreenState extends State<PersonsListScreen> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchPeopleProvider = Provider.of<SearchPeople>(context);
    return Scaffold(
      drawer: Drawer(
        child: DrawerBody(),
      ),
      appBar: buildNavBar(
          context: context,
          routeName: PersonsListScreen.routeName,
          title: "Szukaj"),
      body: searchPeopleProvider.users.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.grey[300]),
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 100),
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: new TextFormField(
                    onFieldSubmitted: (s) {
                      searchPeopleProvider.searchPeopleList(s).then((_) {
                        myController.clear();
                      });
                    },
                    controller: myController,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Podaj imię i nazwisko',
                    ),
                  ),
                ),
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.grey[300]),
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: new TextFormField(
                    onFieldSubmitted: (s) {
                      searchPeopleProvider.searchPeopleList(s).then((_) {
                        myController.clear();
                      });
                    },
                    controller: myController,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Podaj imię i nazwisko',
                    ),
                  ),
                ),
                ...searchPeopleProvider.users.map(
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
                                            onPressed: () {
                                              searchPeopleProvider
                                                  .sendFriendRequest(
                                                      person.userId)
                                                  .then((response) {
                                                print(response);
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            Text('Zaproszenie'),
                                                        content: Text(
                                                            '${!response ? "BŁĄD! Nie zaproszono " : "Zaproszono "} do znajomych!'),
                                                        actions: [
                                                          TextButton(
                                                            child: Text(
                                                                'Zrozumiano'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    }).then((_) => Navigator.of(
                                                        context)
                                                    .pop());
                                              });
                                            },
                                            child: Text("Dodaj do znajomych")),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                            minWidth: double.infinity,
                                            onPressed: () {
                                              final userDataProvider =
                                                  Provider.of<UserData>(context,
                                                      listen: false);
                                              userDataProvider
                                                  .getAnotherUserData(
                                                      person.userId)
                                                  .then((data) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserProfileScreen(
                                                              postsCount:
                                                                  data.posts[0],
                                                              trainingsCount:
                                                                  data.posts[1],
                                                              dietsCount:
                                                                  data.posts[2],
                                                              id: person.userId,
                                                              friend:
                                                                  data.isFriend,
                                                              rootUser: false,
                                                              userImage:
                                                                  data.image,
                                                              userName:
                                                                  data.name,
                                                            )));
                                              });
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
