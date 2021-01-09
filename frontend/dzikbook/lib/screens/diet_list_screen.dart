import 'package:dzikbook/screens/add_diet_screen.dart';
import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';

import '../widgets/diet_list.dart';

class DietListScreen extends StatelessWidget {
  static final routeName = '/dietsList';
  @override
  Widget build(BuildContext context) {
    final addToPlan = ModalRoute.of(context).settings.arguments as bool;

    return Scaffold(
      drawer: Drawer(
        child: DrawerBody(),
      ),
      appBar: buildNavBar(
          context: context,
          routeName: DietListScreen.routeName,
          title: 'Diety'),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: ListTile(
                leading: Text(
                  "Diety",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 30),
                  textAlign: TextAlign.start,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddDietScreen.routeName);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                    size: 25,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: DietList(
                addToPlans: addToPlan,
              ),
            )
          ],
        ),
      ),
    );
  }
}
