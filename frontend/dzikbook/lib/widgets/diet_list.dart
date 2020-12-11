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
                  height: 30,
                ),
                title: Text(
                  diets[i].name,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${diets[i].dietCalories} kcal',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.7)),
                    ),
                    Visibility(
                        visible: addToPlans,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                            size: 22,
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
