import 'package:flutter/material.dart';

class StaticDetailTile extends StatelessWidget {
  const StaticDetailTile({
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
      child: SizedBox(
        width: deviceSize.width * 0.65,
        child: ListTile(
          title: Text(
            categoryType,
            style: TextStyle(fontSize: 18),
          ),
          trailing: SizedBox(
            width: deviceSize.width * 0.20,
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
