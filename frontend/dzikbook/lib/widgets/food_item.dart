import 'package:flutter/material.dart';

import '../providers/diets.dart';

class FoodItem extends StatelessWidget {
  final Food foodData;
  FoodItem({this.foodData});

  Widget _buildTiles(Food root) {
    return ExpansionTile(
      key: PageStorageKey<Food>(root),
      title: Text(
        root.name,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      children: [
        FoodRow(
          categoryType: "Białko",
          dataText: foodData.protein.toString(),
          name: root.name,
          units: 'g',
        ),
        FoodRow(
          categoryType: "Kalorie",
          dataText: foodData.calories.toString(),
          name: root.name,
          units: '',
        ),
        FoodRow(
          categoryType: "Węgle",
          dataText: foodData.carbs.toString(),
          name: root.name,
          units: "g",
        ),
        FoodRow(
          categoryType: "Tłuszcz",
          dataText: foodData.fat.toString(),
          name: root.name,
          units: "g",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(foodData);
  }
}

class FoodRow extends StatelessWidget {
  const FoodRow({
    Key key,
    @required this.categoryType,
    @required this.dataText,
    @required this.name,
    this.units,
  }) : super(key: key);

  final String categoryType;
  final String dataText;
  final String name;
  final String units;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: deviceSize.width * 0.65,
        child: ListTile(
          title: Text(
            categoryType,
            style: TextStyle(fontSize: 18),
          ),
          trailing: SizedBox(
            width: deviceSize.width * 0.15,
            child: Text(
              '$dataText $units',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
