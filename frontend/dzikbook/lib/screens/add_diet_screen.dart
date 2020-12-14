import 'dart:ui';

import 'package:dzikbook/providers/diets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/data_detail_tile.dart';

class AddDietScreen extends StatefulWidget {
  static final routeName = '/addDiet';
  @override
  _AddDietScreenState createState() => _AddDietScreenState();
}

class _AddDietScreenState extends State<AddDietScreen> {
  TextEditingController _nameController;
  TextEditingController _foodController;
  TextEditingController _proteinController;
  TextEditingController _carbsController;
  TextEditingController _fatController;
  TextEditingController _weightController;
  List<Food> _food = [];
  bool _cardVisible = false;
  final _foodForm = GlobalKey<FormState>();
  final _dietForm = GlobalKey<FormState>();
  final _protein = 4;
  final _fat = 9;
  final _carbs = 4;

  @override
  void initState() {
    _nameController = TextEditingController();
    _foodController = TextEditingController();
    _proteinController = TextEditingController();
    _carbsController = TextEditingController();
    _fatController = TextEditingController();
    _weightController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _foodController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  double countCalories(double carbs, double fat, double protein) {
    return carbs * _carbs + fat * _fat + protein * _protein;
  }

  Future<void> _addFood() async {
    final isValid = _foodForm.currentState.validate();
    if (!isValid) {
      return;
    }
    _foodForm.currentState.save();

    final _carbs = roundToFixed(_carbsController.text, 2);
    final _proteins = roundToFixed(_proteinController.text, 2);
    final _fat = roundToFixed(_fatController.text, 2);
    final _weight = roundToFixed(_weightController.text, 2);
    final _sum = _carbs + _proteins + _fat;
    Food newFood = Food(
      id: DateTime.now().toIso8601String(),
      name: _foodController.text,
      weight: _weight >= _sum ? _weight : _sum,
      protein: _proteins,
      calories: countCalories(_carbs, _fat, _proteins),
      carbs: _carbs,
      fat: _fat,
    );
    _food.add(newFood);
    _clearControllers();
    setState(() {
      _cardVisible = false;
    });
  }

  void _clearControllers() {
    _foodController.text = '';
    _proteinController.text = '';
    _carbsController.text = '';
    _fatController.text = '';
    _weightController.text = '';
  }

  double roundToFixed(String number, int places) {
    return double.parse(double.parse(number).toStringAsFixed(places));
  }

  Future<void> _addDiet() async {
    final isValid = _dietForm.currentState.validate();
    if (!isValid) {
      return;
    }
    final _dietProvider = Provider.of<Diets>(context, listen: false);
    final totalCalories = await _dietProvider.sumCalories(_food);
    Diet newDiet = Diet(
      name: _nameController.text,
      dietCalories: totalCalories.round(),
      foodList: _food,
    );
    _dietProvider.addDiet(newDiet);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tworzenie diety"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (_food.isEmpty) {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text("Błąd!"),
                            content: Text(
                                "Nie dodano żadnych posiłków do tej diety!"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("Okej"))
                            ],
                          ));
                } else {
                  _addDiet();
                }
              })
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _dietForm,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: deviceSize.width * 0.6,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nazwa',
                      ),
                      textAlign: TextAlign.center,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Pole wymagane';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    title: Text(
                      "Posiłki",
                      style: TextStyle(fontSize: 22),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _cardVisible = true;
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: _food.length,
                      itemBuilder: (context, id) {
                        return ListTile(
                          title: Text(_food[id].name),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey[700],
                            ),
                            onPressed: () {
                              _food.removeAt(id);
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: deviceSize.height * 0.25,
            left: deviceSize.width * 0.1,
            child: Visibility(
              visible: _cardVisible,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: deviceSize.height * 0.5,
                  width: deviceSize.width * 0.8,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      child: Form(
                        key: _foodForm,
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            ListTile(
                              title: TextFormField(
                                controller: _foodController,
                                decoration: InputDecoration(
                                  hintText: 'Nazwa posiłku',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return ' ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DataDetailTile(
                              deviceSize: deviceSize,
                              textController: _weightController,
                              title: "Waga (g)",
                            ),
                            DataDetailTile(
                              deviceSize: deviceSize,
                              textController: _proteinController,
                              title: "Białko (g)",
                            ),
                            DataDetailTile(
                              deviceSize: deviceSize,
                              textController: _carbsController,
                              title: "Węgle (g)",
                            ),
                            DataDetailTile(
                              deviceSize: deviceSize,
                              textController: _fatController,
                              title: "Tłuszcz (g)",
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.02,
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceEvenly,
                              // buttonHeight: 30,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _cardVisible = false;
                                      _clearControllers();
                                    });
                                  },
                                  child: Text(
                                    'Anuluj',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: _addFood,
                                  child: Text(
                                    'Dodaj',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
