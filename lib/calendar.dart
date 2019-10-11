import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/globals.dart' as globals;

class Calendar extends StatefulWidget {
  DateTime _currentMonth;
  DateTime _lastDayOfCurrentMonth;

  Calendar() {
    sortOutDates();
  }

  @override
  _CalendarState createState() => _CalendarState();

  void sortOutDates() {
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

    _lastDayOfCurrentMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, _currentMonth.day)
            .add(Duration(days: -1));
  }
}

List<String> DaysOfWeek = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

class _CalendarState extends State<Calendar> {
  void addMonth() {
    setState(() {
      this.widget._currentMonth = DateTime(this.widget._currentMonth.year,
          this.widget._currentMonth.month + 1, 1);

      this.widget._lastDayOfCurrentMonth = DateTime(
              this.widget._currentMonth.year,
              this.widget._currentMonth.month + 1,
              this.widget._currentMonth.day)
          .add(Duration(days: -1));
    });
  }

  bool DayCompleted(int dayOfMonth) {
    //bool x = true;
     String dt = globals.getDayKey(DateTime(
        this.widget._currentMonth.year,
        this.widget._currentMonth.month,
        dayOfMonth));
  
        //print(dt);
    return globals.days.days.containsKey(dt) &&
        globals.days.days[dt].complete();
    //return x;
  }

  void subtractMonth() {
    setState(() {
      this.widget._currentMonth = DateTime(this.widget._currentMonth.year,
          this.widget._currentMonth.month - 1, 1);

      this.widget._lastDayOfCurrentMonth = DateTime(
              this.widget._currentMonth.year,
              this.widget._currentMonth.month + 1,
              this.widget._currentMonth.day)
          .add(Duration(days: -1));
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
                setState(() {
                  this.widget._currentMonth =
                      DateTime(DateTime.now().year, DateTime.now().month, 1);

                  this.widget._lastDayOfCurrentMonth = DateTime(
                          this.widget._currentMonth.year,
                          this.widget._currentMonth.month + 1,
                          this.widget._currentMonth.day)
                      .add(Duration(days: -1));
                });
              },
              child: new Text(
                new DateFormat("LLL yyyy").format(this.widget._currentMonth),
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
        )
      ],
    );
  }
}
