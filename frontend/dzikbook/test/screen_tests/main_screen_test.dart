import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  testWidgets("Checking Post Widget", (WidgetTester tester) async {
    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData.fromWindow(ui.window),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Scaffold(
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.green,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage("XDD"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter)),
                            ),
                            Text(
                              "XD",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                            Text(
                              "15s",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 10, left: 15, bottom: 10, right: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SelectableText(
                        "CZEŚĆ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          letterSpacing: .2,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
      expect(find.text("CZEŚĆ"), findsOneWidget);
      expect(find.text("XD"), findsOneWidget);
      expect(find.text("XDD"), findsNothing);
      expect(find.text("15s"), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(3));
      expect(find.byType(Row), findsNWidgets(3));
    });
  });
}
