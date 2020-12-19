import 'package:dzikbook/providers/friends.dart';
import 'package:dzikbook/providers/search_people.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
                                            onPressed: () {},
                                            child: Text("Dodaj do znajomych")),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                            minWidth: double.infinity,
                                            onPressed: () {
                                              final friendsProvider =
                                                  Provider.of<Friends>(context,
                                                      listen: false);
                                              friendsProvider
                                                  .deleteUserFromFriends(
                                                      person.userId)
                                                  .then((response) {
                                                Navigator.of(context).pop();
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
