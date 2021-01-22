import 'package:dzikbook/providers/auth.dart';
import 'package:dzikbook/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DrawerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/dzik.svg',
                  width: 140,
                  color: Colors.white,
                ),
                Positioned(
                  right: 15,
                  bottom: 10,
                  child: Text(
                    'Cześć!',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DrawerItem(
            routeName: '/profile',
            icon: Icons.home,
            title: 'Tablica',
          ),
          DrawerItem(
            routeName: '/friends-list',
            icon: Icons.people,
            title: 'Znajomi',
          ),
          DrawerItem(
            routeName: '/workoutsList',
            icon: Icons.fitness_center,
            title: 'Treningi',
          ),
          DrawerItem(
            routeName: '/dietsList',
            icon: Icons.food_bank,
            title: 'Diety',
          ),
          DrawerItem(
            routeName: '/calendarPlans',
            icon: Icons.calendar_today,
            title: 'Kalendarz',
          ),
          DrawerItem(
            routeName: '/invitations-list',
            icon: Icons.group_add,
            title: 'Zaproszenia',
          ),
          ListTile(
            onTap: () {
              Provider.of<Auth>(context).logout();
              Navigator.of(context).pushReplacementNamed('/auth');
            },
            leading: Icon(
              Icons.logout,
              size: 30,
            ),
            title: Text(
              "Wyloguj",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
