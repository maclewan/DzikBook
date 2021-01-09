import 'package:flutter/material.dart';

import '../providers/diets.dart';
import './static_detail_tile.dart';

class FoodItem extends StatelessWidget {
  final Food foodData;
  FoodItem({this.foodData});

  Widget _buildTiles(Food root) {
    return ExpansionTile(
      key: PageStorageKey<Food>(root),
      title: Text(
        root.name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${root.weight.toString()} g',
      ),
      children: [
        StaticDetailTile(
          categoryType: "Białko",
          dataText: foodData.protein.toString(),
          name: root.name,
          units: 'g',
        ),
        StaticDetailTile(
          categoryType: "Kalorie",
          dataText: foodData.calories.toString(),
          name: root.name,
          units: '',
        ),
        StaticDetailTile(
          categoryType: "Węgle",
          dataText: foodData.carbs.toString(),
          name: root.name,
          units: "g",
        ),
        StaticDetailTile(
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
