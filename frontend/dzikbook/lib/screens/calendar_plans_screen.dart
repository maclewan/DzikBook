//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:dzikbook/screens/diet_screen.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../providers/dayPlans.dart';
import '../providers/workouts.dart';
import '../providers/diets.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class CalendarPlansScreen extends StatefulWidget {
  CalendarPlansScreen({Key key, this.title}) : super(key: key);

  final String title;
  static final routeName = '/calendarPlans';

  @override
  _CalendarPlansScreenState createState() => _CalendarPlansScreenState();
}

class _CalendarPlansScreenState extends State<CalendarPlansScreen>
    with TickerProviderStateMixin {
  Map<DateTime, List<Object>> _events;
  List _selectedEvents;
  DateTime _selectedDay;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _nowDate = DateTime.now();
    _selectedDay = DateTime(_nowDate.year, _nowDate.month, _nowDate.day);
    final plansData = Provider.of<DayPlans>(context, listen: false);
    Workout plan = Workout(name: "Trening 2", workoutLength: 30, exercises: [
      Exercise(id: "1", name: "ex1", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "2", name: "ex2", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "3", name: "ex3", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "4", name: "ex4", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "5", name: "ex5", series: 3, reps: 4, breakTime: 90),
    ]);

    Diet plan2 = Diet(name: "Dieta 1", dietCalories: 30, foodList: [
      Food(
          id: "1",
          name: "ex1",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "2",
          name: "ex2",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "3",
          name: "ex3",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "4",
          name: "ex4",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "5",
          name: "ex5",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
    ]);
    DateTime date = DateTime(_nowDate.year, _nowDate.month, _nowDate.day);
    // print(date);
    plansData.addWorkoutPlan(plan, date);
    plansData.addDietPlan(plan2, date);
    _events = plansData.allPlans;
    // print(_events);
    // _events = {
    //   _selectedDay.subtract(Duration(days: 30)): [
    //     'Event A0',
    //     'Event B0',
    //     'Event C0'
    //   ],
    //   _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
    //   _selectedDay.subtract(Duration(days: 20)): [
    //     'Event A2',
    //     'Event B2',
    //     'Event C2',
    //     'Event D2'
    //   ],
    //   _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
    //   _selectedDay.subtract(Duration(days: 10)): [
    //     'Event A4',
    //     'Event B4',
    //     'Event C4'
    //   ],
    //   _selectedDay.subtract(Duration(days: 4)): [
    //     'Event A5',
    //     'Event B5',
    //     'Event C5'
    //   ],
    //   _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
    //   _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    //   _selectedDay.add(Duration(days: 1)): [
    //     'Event A8',
    //     'Event B8',
    //     'Event C8',
    //     'Event D8'
    //   ],
    //   _selectedDay.add(Duration(days: 3)):
    //       Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
    //   _selectedDay.add(Duration(days: 7)): [
    //     'Event A10',
    //     'Event B10',
    //     'Event C10'
    //   ],
    //   _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
    //   _selectedDay.add(Duration(days: 17)): [
    //     'Event A12',
    //     'Event B12',
    //     'Event C12',
    //     'Event D12'
    //   ],
    //   _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
    //   _selectedDay.add(Duration(days: 26)): [
    //     'Event A14',
    //     'Event B14',
    //     'Event C14'
    //   ],
    // };

    print(_events[_selectedDay]);
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          // _buildTableCalendar(),
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 30.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
        todayColor: Theme.of(context).primaryColor,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          )),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              margin: const EdgeInsets.all(4.0),
              // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              // color: Theme.of(context).primaryColor,
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            // color: Colors.lightGreen,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.pink[500]
            : _calendarController.isToday(date)
                ? Colors.pink[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final plansData = Provider.of<DayPlans>(context);

    void _setEvents(events) {
      setState(() {
        _events = events;
        List tempEvents;
        DateTime tempDate =
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
        if (_events.containsKey(tempDate)) {
          tempEvents = _events[tempDate];
        } else {
          tempEvents = [];
        }
        _onDaySelected(tempDate, tempEvents, []);
      });
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _setEvents(plansData.workoutPlans);
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                "Treningi",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // RaisedButton(
            RaisedButton(
              onPressed: () {
                _setEvents(plansData.allPlans);
              },
              color: Colors.pink[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                "Wszystko",
                style: TextStyle(color: Colors.white),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _setEvents(plansData.dietPlans);
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                "Diety",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _selectedEvents.isEmpty
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Column(
        children: [
          Center(
              child: Text(
            "Plany",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
          )),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, id) {
                final event = _selectedEvents[id];
                String picture = 'assets/images/diet.svg';
                String trailingData = 'xd';
                var nav;
                if (event is Workout) {
                  picture = 'assets/images/dumbbell.svg';
                  trailingData = '${event.workoutLength} min';
                  nav = () {
                    Navigator.of(context)
                        .pushNamed(WorkoutScreen.routeName, arguments: event);
                  };
                } else {
                  trailingData = '${event.dietCalories} kcal';
                  nav = () {
                    Navigator.of(context)
                        .pushNamed(DietScreen.routeName, arguments: event);
                  };
                }
                return ListTile(
                  onTap: nav,
                  leading: SvgPicture.asset(
                    picture,
                    color: Colors.black,
                    height: 40,
                  ),
                  title: Text(
                    event.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    trailingData,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
