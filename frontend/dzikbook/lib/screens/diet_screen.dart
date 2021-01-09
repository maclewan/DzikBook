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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(dietData.name),
      ),
      body: Container(
        width: deviceSize.width,
        child: Column(
          children: [
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
