import 'package:flutter/material.dart';

import '../providers/workouts.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exerciseData;
  ExerciseItem({this.exerciseData});

  Widget _buildTiles(Exercise root) {
    return ExpansionTile(
      key: PageStorageKey<Exercise>(root),
      title: Text(
        root.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      // tilePadding: EdgeInsets.symmetric(horizontal: 30),
      backgroundColor: Colors.white,
      children: [
        ExerciseRow(
          categoryType: "Serie",
          dataText: exerciseData.series.toString(),
          name: root.name,
          units: '',
        ),
        ExerciseRow(
          categoryType: "Powtórzenia",
          dataText: exerciseData.reps.toString(),
          name: root.name,
          units: '',
        ),
        ExerciseRow(
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

class ExerciseRow extends StatelessWidget {
  const ExerciseRow({
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
              '${dataText} ${units}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          // trailing: Container(
          //   width: deviceSize.width * 0.1,
          //   height: 30,
          //   decoration: BoxDecoration(
          //       border:
          //           Border.all(color: Color.fromRGBO(0, 0, 0, 0.2), width: 1)),
          //   child: Center(
          //     child: TextField(
          //       textAlign: TextAlign.center,
          //       key: PageStorageKey(name + categoryType),
          //       controller: TextEditingController()..text = dataText,
          //       onChanged: (text) {
          //         print(text);
          //       },
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
