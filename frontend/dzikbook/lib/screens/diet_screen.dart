import 'package:flutter/material.dart';

import '../providers/diets.dart';
import '../widgets/food_item.dart';

class DietScreen extends StatelessWidget {
  static final routeName = '/diet';

  @override
  Widget build(BuildContext context) {
    final dietData = ModalRoute.of(context).settings.arguments as Diet;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: deviceSize.width,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              dietData.name,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dietData.foodList.length,
                itemBuilder: (context, id) => FoodItem(
                  foodData: dietData.foodList[id],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
