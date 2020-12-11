import 'package:flutter/material.dart';

import '../providers/workouts.dart';
import '../widgets/static_detail_tile.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exerciseData;
  ExerciseItem({this.exerciseData});

  Widget _buildTiles(Exercise root) {
    return ExpansionTile(
      key: PageStorageKey<Exercise>(root),
      title: Text(
        root.name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      children: [
        StaticDetailTile(
          categoryType: "Serie",
          dataText: exerciseData.series.toString(),
          name: root.name,
          units: '',
        ),
        StaticDetailTile(
          categoryType: "Powtórzenia",
          dataText: exerciseData.reps.toString(),
          name: root.name,
          units: '',
        ),
        StaticDetailTile(
          categoryType: "Przerwy",
          dataText: exerciseData.breakTime.toString(),
          name: root.name,
          units: "sec",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(exerciseData);
  }
}
