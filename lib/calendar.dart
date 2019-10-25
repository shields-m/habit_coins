import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:habit_coins/localData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipedetector/swipedetector.dart';

class Calendar extends StatefulWidget {
  DateTime _currentMonth;
  String _currentMonthName;
  DateTime _lastDayOfCurrentMonth;

  Calendar() {
    sortOutDates();
  }

  @override
  _CalendarState createState() => _CalendarState();

  void sortOutDates() {
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _currentMonthName = new DateFormat("LLL yyyy").format(_currentMonth);
    _lastDayOfCurrentMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, _currentMonth.day)
            .add(Duration(days: -1));
  }
}

List<String> DaysOfWeek = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

class _CalendarState extends State<Calendar> {
  void addMonth() async {
    DateTime cm = DateTime(
        this.widget._currentMonth.year, this.widget._currentMonth.month + 1, 1);
    if (!cm.isAfter(DateTime(DateTime.now().year, DateTime.now().month, 1))) {
      String cmname = new DateFormat("LLL yyyy").format(cm);

      DateTime ldocm =
          DateTime(cm.year, cm.month + 1, cm.day).add(Duration(days: -1));

      if (!globals.monthsList.Months.containsKey(cmname)) {
        if (globals.UseCloudSync) {
          globals.monthsList.Months[cmname] = await getMonthFromCloud(cmname);
        }
      } else {
        if (globals.monthsList.Months[cmname].lastGotFromCloud
            .isBefore(DateTime.now().add(Duration(days: -1)))) {
          globals.monthsList.Months[cmname] = await getMonthFromCloud(cmname);
        }
      }

      setState(() {
        this.widget._currentMonth = cm;
        this.widget._currentMonthName = cmname;
        this.widget._lastDayOfCurrentMonth = ldocm;
      });
    }
    else
    {
Fluttertoast.showToast(
          msg: "The future is currently unknown",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0);

    }
  }

  void thisMonth() async {
    DateTime cm = DateTime(DateTime.now().year, DateTime.now().month, 1);

    String cmname = new DateFormat("LLL yyyy").format(cm);

    DateTime ldocm =
        DateTime(cm.year, cm.month + 1, cm.day).add(Duration(days: -1));

    if (!globals.monthsList.Months.containsKey(cmname)) {
      if (globals.UseCloudSync) {
        globals.monthsList.Months[cmname] = await getMonthFromCloud(cmname);
      }
    } else {
      if (globals.monthsList.Months[cmname].lastGotFromCloud
          .isBefore(DateTime.now().add(Duration(days: -1)))) {
        globals.monthsList.Months[cmname] = await getMonthFromCloud(cmname);
      }
    }

    setState(() {
      this.widget._currentMonth = cm;
      this.widget._currentMonthName = cmname;
      this.widget._lastDayOfCurrentMonth = ldocm;
    });
  }

  bool DayCompleted(int dayOfMonth) {
    //bool x = true;
    String dt = globals.getDayKey(DateTime(this.widget._currentMonth.year,
        this.widget._currentMonth.month, dayOfMonth));

    //print(dt);
    return globals.monthsList.Months
            .containsKey(this.widget._currentMonthName) &&
        globals.monthsList.Months[this.widget._currentMonthName].DaysCompleted
            .contains(dt);
    //return x;
  }

  void subtractMonth() async {
    DateTime cm = DateTime(
        this.widget._currentMonth.year, this.widget._currentMonth.month - 1, 1);

    String cmname = new DateFormat("LLL yyyy").format(cm);

    DateTime ldocm =
        DateTime(cm.year, cm.month + 1, cm.day).add(Duration(days: -1));

    if (!globals.monthsList.Months.containsKey(cmname)) {
      if (globals.UseCloudSync) {
        globals.monthsList.Months[cmname] = await getMonthFromCloud(cmname);
      }
    } else {
      if (globals.monthsList.Months[cmname].lastGotFromCloud
          .isBefore(DateTime.now().add(Duration(days: -1)))) {
        globals.monthsList.Months[cmname] = await getMonthFromCloud(cmname);
      }
    }

    setState(() {
      this.widget._currentMonth = cm;
      this.widget._currentMonthName = cmname;
      this.widget._lastDayOfCurrentMonth = ldocm;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int offset = 7 + this.widget._currentMonth.weekday - 1;
    //print(offset);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                subtractMonth();
              },
              child: new Icon(
                Icons.keyboard_arrow_left,
                size: 32,
              ),
            ),
            new GestureDetector(
              onTap: () {
                thisMonth();
              },
              child: new Text(
                this.widget._currentMonthName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            new GestureDetector(
              onTap: () {
                addMonth();
              },
              child: new Icon(
                Icons.keyboard_arrow_right,
                size: 32,
              ),
            ),
          ],
        ),
        SwipeDetector(
          onSwipeLeft: () => addMonth(),
          onSwipeRight: () => subtractMonth(),
          child:
        GridView.count(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          crossAxisCount: 7,
          children: List.generate(
              this.widget._lastDayOfCurrentMonth.day + (offset), (index) {
            return Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: index < 7
                    ? Color.fromARGB(255, 53, 83, 165)
                    : DateTime(
                                this.widget._currentMonth.year,
                                this.widget._currentMonth.month,
                                ((index) - (offset) + 1)) ==
                            today
                        ? Color.fromARGB(128, 53, 83, 165)
                        : Colors.white,
                border: Border.all(
                  color: Color.fromARGB(128, 53, 83, 165),
                  width: 1,
                ),
                //borderRadius: BorderRadius.circular(16.0),
              ),
              child: index < 7
                  ? Center(
                      child: Text(
                        DaysOfWeek[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : (index) >= (offset)
                      ? Stack(
                          children: <Widget>[
                            DayCompleted(((index) - (offset) + 1))
                                ? Container(
                                    padding: EdgeInsets.all(3),
                                    child: Image.asset(
                                      'assets/images/thumbsup-small.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : Container(),
                            Text(
                              ((index) - (offset) + 1).toString(),
                              style: TextStyle(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Container(),
            );
          }),
        ),
        ),
      ],
    );
  }
}
