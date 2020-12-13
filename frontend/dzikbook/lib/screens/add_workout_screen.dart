import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/static.dart';
import '../providers/workouts.dart';

import '../widgets/data_detail_tile.dart';

class AddWorkoutScreen extends StatefulWidget {
  static final routeName = '/addWorkout';
  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  TextEditingController _nameController;
  TextEditingController _exerciseController;
  TextEditingController _seriesController;
  TextEditingController _repsController;
  TextEditingController _breakTimeController;
  List<Exercise> _exercises = [];
  bool _cardVisible = false;
  String exerciseName = 'Wybierz ćwiczenie';
  final _exerciseForm = GlobalKey<FormState>();
  final _workoutForm = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _exerciseController = TextEditingController();
    _seriesController = TextEditingController();
    _repsController = TextEditingController();
    _breakTimeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _exerciseController.dispose();
    super.dispose();
  }

  Future<void> _addExercise() async {
    final isValid = _exerciseForm.currentState.validate();
    if (!isValid) {
      return;
    }
    _exerciseForm.currentState.save();
    Exercise newExercise = Exercise(
      id: DateTime.now().toIso8601String(),
      name: _exerciseController.text,
      series: int.parse(_seriesController.text.toString()),
      reps: int.parse(_repsController.text.toString()),
      breakTime: int.parse(_breakTimeController.text.toString()),
    );
    _exercises.add(newExercise);
    _clearControllers();
    setState(() {
      _cardVisible = false;
    });
  }

  void _clearControllers() {
    _exerciseController.text = '';
    _seriesController.text = '';
    _repsController.text = '';
    _breakTimeController.text = '';
  }

  Future<void> _addWorkout() async {
    final isValid = _workoutForm.currentState.validate();
    if (!isValid) {
      return;
    }
    final _workoutProvider = Provider.of<Workouts>(context, listen: false);
    final workoutTime = await _workoutProvider.countWorkoutLength(_exercises);
    Workout newWorkout = Workout(
        name: _nameController.text,
        workoutLength: (workoutTime / 60).ceil(),
        exercises: _exercises);
    _workoutProvider.addWorkout(newWorkout);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tworzenie treningu"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              onPressed: () {
                if (_exercises.isEmpty) {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text("Błąd!"),
                            content: Text(
                                "Nie dodano żadnych ćwiczeń do tego treningu!"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("Okej"))
                            ],
                          ));
                } else {
                  _addWorkout();
                }
              })
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _workoutForm,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: deviceSize.width * 0.6,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nazwa treningu',
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
                      "Ćwiczenia",
                      style: const TextStyle(fontSize: 22),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(
                          () {
                            _cardVisible = true;
                          },
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: _exercises.length,
                      itemBuilder: (context, id) {
                        return ListTile(
                          title: Text(_exercises[id].name),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey[700],
                            ),
                            onPressed: () {
                              _exercises.removeAt(id);
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
                  height: deviceSize.height * 0.45,
                  width: deviceSize.width * 0.8,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      child: Form(
                        key: _exerciseForm,
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            ListTile(
                              onTap: () async {
                                final response = await showSearch(
                                  context: context,
                                  delegate: ExerciseSearch(),
                                );
                                if (response != null)
                                  _exerciseController.text = response;
                              },
                              title: TextFormField(
                                controller: _exerciseController,
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: 'Wybierz ćwiczenie',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return ' ';
                                  }
                                  return null;
                                },
                              ),
                              trailing: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DataDetailTile(
                              deviceSize: deviceSize,
                              textController: _seriesController,
                              title: "Serie",
                            ),
                            DataDetailTile(
                              deviceSize: deviceSize,
                              textController: _repsController,
                              title: "Powtórzenia",
                            ),
                            DataDetailTile(
                              deviceSize: deviceSize,
                              textController: _breakTimeController,
                              title: "Przerwa (sek)",
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.03,
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
                                  onPressed: _addExercise,
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

class ExerciseSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final allItems = Provider.of<Static>(context, listen: false).exerciseNames;
    final suggestions = query.isEmpty
        ? allItems
        : allItems
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return suggestions.isEmpty
        ? Text(
            'Nie znaleziono...',
            style: TextStyle(
              fontSize: 20,
            ),
          )
        : ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestions[index]),
                onTap: () {
                  close(context, suggestions[index]);
                },
              );
            },
          );
  }

  @override
  String get searchFieldLabel => "Szukaj ćwiczenia...";
}
