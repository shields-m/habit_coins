import 'package:flutter/material.dart';
import 'package:habit_coins/models.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:habit_coins/localData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipedetector/swipedetector.dart';

class Calendar extends StatefulWidget {
  DateTime _currentMonth;
  String _currentMonthName;
  DateTime _lastDayOfCurrentMonth;
  bool isMe;
  String UserID;

  Calendar() {
    isMe = true;
    sortOutDates();
  }

  Calendar.forOtherUser(String user) {
    isMe = user == globals.CurrentUser;
    UserID = user;
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
      if (this.widget.isMe) {
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
      } else {
        if (!globals.people[this.widget.UserID].months.Months
            .containsKey(cmname)) {
          globals.people[this.widget.UserID].months.Months[cmname] =
              await getMonthFromCloudForUser(cmname, this.widget.UserID);
        }
      }

      setState(() {
        this.widget._currentMonth = cm;
        this.widget._currentMonthName = cmname;
        this.widget._lastDayOfCurrentMonth = ldocm;
      });
    } else {
      Fluttertoast.showToast(
          msg: "The future is currently unknown",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
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

    if (this.widget.isMe) {
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
    } else {
      if (!globals.people[this.widget.UserID].months.Months
          .containsKey(cmname)) {
        globals.people[this.widget.UserID].months.Months[cmname] =
              await getMonthFromCloudForUser(cmname, this.widget.UserID);
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
    if (this.widget.isMe) {
      return globals.monthsList.Months
              .containsKey(this.widget._currentMonthName) &&
          globals.monthsList.Months[this.widget._currentMonthName].DaysCompleted
              .contains(dt);
    } else {
      return globals.people[this.widget.UserID].months.Months
              .containsKey(this.widget._currentMonthName) &&
          globals.people[this.widget.UserID].months
              .Months[this.widget._currentMonthName].DaysCompleted
              .contains(dt);
    }
    //return x;
  }


  void showDay(int dayOfMonth) async {
    DateTime date = DateTime(this.widget._currentMonth.year,
        this.widget._currentMonth.month, dayOfMonth);
    String dt = globals.getDayKey(date);

    print(dt);

    Day d;
    if (this.widget.isMe) {
      if (globals.UseCloudSync) {
        if (!globals.days.days.containsKey(dt)) {
          globals.days.days[dt] = await getDayFromCloud(date);
        }
      }
      d = globals.days.days[dt];
    } else {
      if (!globals.people[this.widget.UserID].days.days.containsKey(dt)) {
        globals.people[this.widget.UserID].days.days[dt] =
            await getDayFromCloudForUser(date, this.widget.UserID);
      }

      d = globals.people[this.widget.UserID].days.days[dt];
    }

    if (d.totalCoinCount() > 0) {
      showDialog(
        context: context,
        
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(dt.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            content: Container(
              // Specify some width
              width: MediaQuery.of(context).size.width * .8,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child:Center(
                    child: Text('HabitCoins In Jar'),
                  ),),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    children: d.coinsInJar
                        .map(
                          (coin) => Container(
                            margin: EdgeInsets.all(3),
                            width: 90.0,
                            height: 90.0,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0.0, 0),
                                )
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                coin.Icon,
                                size: 36,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child:Center(
                    child: Text('Uncompleted HabitCoins'),
                  ),),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    children: d.pendingCoins
                        .map(
                          (coin) => Container(
                            margin: EdgeInsets.all(3),
                            width: 90.0,
                            height: 90.0,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0.0, 0),
                                )
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                coin.Icon,
                                size: 36,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "No HabitCoin Data for selected day",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void subtractMonth() async {
    DateTime cm = DateTime(
        this.widget._currentMonth.year, this.widget._currentMonth.month - 1, 1);

    String cmname = new DateFormat("LLL yyyy").format(cm);

    DateTime ldocm =
        DateTime(cm.year, cm.month + 1, cm.day).add(Duration(days: -1));

    if (this.widget.isMe) {
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
    } else {
      if (!globals.people[this.widget.UserID].months.Months
          .containsKey(cmname)) {
        globals.people[this.widget.UserID].months.Months[cmname] =
              await getMonthFromCloudForUser(cmname, this.widget.UserID);
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
          swipeConfiguration: SwipeConfiguration(
            verticalSwipeMinVelocity: 9999,
            verticalSwipeMinDisplacement: 9999,
            verticalSwipeMaxWidthThreshold: 9999,
          ),
          onSwipeUp: () => null,
          onSwipeDown: () => null,
          onSwipeLeft: () => addMonth(),
          onSwipeRight: () => subtractMonth(),
          child: GridView.count(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            crossAxisCount: 7,
            children: List.generate(
                this.widget._lastDayOfCurrentMonth.day + (offset), (index) {
              return GestureDetector(
                onTap: () => showDay(((index) - (offset) + 1)),
                child: Container(
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
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
