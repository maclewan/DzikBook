import 'package:dzikbook/screens/diet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/diets.dart';

class DietList extends StatelessWidget {
  final bool addToPlans;

  DietList({this.addToPlans});

  @override
  Widget build(BuildContext context) {
    final dietsData = Provider.of<Diets>(context);
    final diets = dietsData.diets;
    return ListView.builder(
      shrinkWrap: true,
      // scrollDirection: Axis.horizontal,
      itemCount: diets.length,
      itemBuilder: (context, i) {
        // return Text(workouts[i].name);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  DietScreen.routeName,
                  arguments: diets[i],
                );
              },
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/diet.svg',
                ),
                title: Text(
                  diets[i].name,
                  style: TextStyle(
                      fontSize: 22,
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${diets[i].dietCalories} kcal',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(0, 0, 0, 0.7)),
                    ),
                    Visibility(
                        visible: addToPlans,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(diets[i]);
                          },
                        ))
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 0,
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
