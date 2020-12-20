import 'package:dzikbook/screens/diet_list_screen.dart';
import 'package:dzikbook/screens/diet_screen.dart';
import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../providers/day_plans.dart';
import '../providers/workouts.dart';
import '../providers/diets.dart';

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
  bool _workoutButton = false;
  bool _allButton = true;
  bool _dietButton = false;
  bool owner;

  @override
  void initState() {
    super.initState();
    owner = true;
    final _nowDate = DateTime.now();
    _selectedDay = DateTime(_nowDate.year, _nowDate.month, _nowDate.day);
    final plansData = Provider.of<DayPlans>(context, listen: false);
    _events = plansData.allPlans;

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
      appBar: buildNavBar(
          context: context,
          routeName: CalendarPlansScreen.routeName,
          title: 'Kalendarz'),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          SizedBox(
            height: owner ? 0 : 20,
          ),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

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
                border: Border.all(color: Colors.green[800], width: 2),
              ),
              margin: const EdgeInsets.all(4.0),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(
                      fontSize: 16.0,
                      color: Colors.green[800],
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green[800],
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
        color: Colors.pink[500],
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

    void _toActive(String name) {
      setState(() {
        _workoutButton = false;
        _allButton = false;
        _dietButton = false;
        if (name == "workout") {
          _workoutButton = true;
        } else if (name == "all") {
          _allButton = true;
        } else if (name == "diet") {
          _dietButton = true;
        }
      });
    }

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

    Future<void> _addWorkoutPlan() async {
      Workout workout = await Navigator.of(context)
          .pushNamed(WorkoutListScreen.routeName, arguments: true) as Workout;
      if (workout == null) return;
      DateTime newDate =
          DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
      await plansData.addWorkoutPlan(workout, newDate);
      _toActive("all");
      _setEvents(plansData.allPlans);
    }

    Future<void> _addDietPlan() async {
      Diet diet = await Navigator.of(context)
          .pushNamed(DietListScreen.routeName, arguments: true) as Diet;
      if (diet == null) return;
      DateTime newDate =
          DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
      await plansData.addDietPlan(diet, newDate);
      _toActive("all");
      _setEvents(plansData.allPlans);
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
                _toActive("workout");
              },
              color: _workoutButton ? Colors.green[800] : Colors.green[300],
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
                _toActive("all");
                _setEvents(plansData.allPlans);
              },
              color: _allButton ? Colors.green[800] : Colors.green[300],
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
                _toActive("diet");
              },
              color: _dietButton ? Colors.green[800] : Colors.green[300],
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
        Visibility(
          visible: owner,
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: _addWorkoutPlan,
                child: Text("dodaj trening"),
              ),
              FlatButton(
                onPressed: _addDietPlan,
                child: Text("dodaj dietę"),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildEventList() {
    return Visibility(
      visible: _selectedEvents.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
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
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 15,
                ),
                itemCount: _selectedEvents.length,
                itemBuilder: (context, id) {
                  final event = _selectedEvents[id];
                  String picture = 'assets/images/diet.svg';
                  String trailingData = '';
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
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      dense: true,
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10)),
                      // tileColor: Colors.white,
                      onTap: nav,
                      leading: SvgPicture.asset(
                        picture,
                        color: Colors.green[700],
                        height: 30,
                      ),
                      title: Text(
                        event.name,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        trailingData,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 17,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
