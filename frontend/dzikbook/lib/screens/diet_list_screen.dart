import 'package:flutter/material.dart';

import '../widgets/diet_list.dart';

class DietListScreen extends StatelessWidget {
  static final routeName = '/dietsList';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment(-0.9, 0.0),
              child: Text(
                "Diety",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 36),
                textAlign: TextAlign.start,
              ),
            ),
            Flexible(
              child: DietList(),
            )
          ],
        ),
      ),
    );
  }
}
