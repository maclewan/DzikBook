import 'package:flutter/widgets.dart';

class Static with ChangeNotifier {
  List<String> _exerciseNames = [
    'Wyciskanie sztangi płasko',
    'Wyciskanie sztangi skos',
    'Wyciskanie żołnierskie',
    'Przysiady',
    'Podciąganie nachwyt',
    'Podciąganie podchwyt',
    'Biceps hantle poziomo',
    'Biceps hantle pionow',
    'Biceps sztanga',
    'Rozpiętki',
  ];

  List<String> get exerciseNames {
    return [..._exerciseNames];
  }
}
