import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habit_coins/localData.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';

GlobalKey<_CoinRowState> _coinRowStateKey = GlobalKey();
DateTime selectedDate;
bool isFuture;
bool isToday;
bool isPast;

class MyCoins extends StatefulWidget {
  MyCoins() {
    selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    isFuture = false;
    isToday = true;
    isPast = false;
  }
  Jar jar = new Jar.fromDay(globals.days.days[DateFormat("yMd").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))]);

  _MyCoinsState createState() => _MyCoinsState();
}

class _MyCoinsState extends State<MyCoins> {
  @override
  Widget build(BuildContext context) {
    // fileWriter w = new fileWriter();
    //w.saveFile(this.widget._coins);
    List<Coin> coins;

    if (globals.ScheduleLoaded && globals.DaysLoaded) {
      if (isFuture) {
        coins = globals.mainSchedule.getCoinsForDay(selectedDate);
      } else {
                    
        coins = globals
            .days.days[DateFormat("yMd").format(selectedDate)].pendingCoins;
            
      }
      return Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    setDate(selectedDate.add(new Duration(days: -1)));
                  },
                  child: new Icon(
                    Icons.keyboard_arrow_left,
                    size: 32,
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    _selectDate();
                  },
                  child: new Text(
                    new DateFormat("E dd LLL yyyy").format(selectedDate),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    setDate(selectedDate.add(new Duration(days: 1)));
                  },
                  child: new Icon(
                    Icons.keyboard_arrow_right,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          CoinRow(
            _coinRowStateKey,
            coins,
          ),
          new Expanded(child: new JarWidget(this.widget.jar)),
        ],
      );
    } else {
      loadSchedule().then((s) {
        loadDays().then((d) {
          setState(() {
            Day today = new Day();
            globals.days = d;
            if (!globals.days.days
                .containsKey(DateFormat("yMd").format(selectedDate))) {
              today.coinsInJar = new List<Coin>();

              today.pendingCoins = s.getCoinsForDay(selectedDate);
              globals.days.days[DateFormat("yMd").format(selectedDate)] = today;
            } else {
              today = globals.days.days[DateFormat("yMd").format(selectedDate)];
            }
            this.widget.jar = new Jar.fromDay(today);
            globals.mainSchedule = s;
            
            //print(json.encode(globals.days));
          });
        });
      });
      return LinearProgressIndicator();
    }
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    if (picked != null) setState(() => setDate(picked));
  }

  void setDate(DateTime dateTime) {
    setState(() {
      DateTime newDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      DateTime now = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);

      selectedDate = newDate;

      if (newDate.isAtSameMomentAs(now)) {
        isToday = true;
        isFuture = false;
        isPast = false;
        if (!globals.days.days.containsKey(DateFormat("yMd").format(newDate))) {
          Day today = new Day();
          today.coinsInJar = new List<Coin>();

          today.pendingCoins = globals.mainSchedule.getCoinsForDay(newDate);
          globals.days.days[DateFormat("yMd").format(newDate)] = today;
        }
        this.widget.jar = new Jar.fromDay(
            globals.days.days[DateFormat("yMd").format(newDate)]);
      } else if (newDate.isAfter(now)) {
        isToday = false;
        isFuture = true;
        isPast = false;
        this.widget.jar = new Jar();
      } else if (newDate.isBefore(now)) {
        isToday = false;
        isFuture = false;
        isPast = true;

        if (!globals.days.days.containsKey(DateFormat("yMd").format(newDate))) {
          Day today = new Day();
          today.coinsInJar = new List<Coin>();

          today.pendingCoins = globals.mainSchedule.getCoinsForDay(newDate);

          globals.days.days[DateFormat("yMd").format(newDate)] = today;
        }
        this.widget.jar = new Jar.fromDay(
            globals.days.days[DateFormat("yMd").format(newDate)]);
      }

      //print(json.encode(globals.days));
    });
  }
}


class ScaleAnimation extends StatefulWidget {
  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    )..addListener(() => setState(() {}));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    
     return ScaleTransition(
          scale: animation,
          child: Container(
            
            child: Image.asset(
              'assets/images/thumbsup.png',
              fit: BoxFit.fitWidth,
              
            ),
          ),
        );
  }
}



class JarWidget extends StatefulWidget {
  Jar _jar;

  JarWidget(Jar jar) {
    _jar = jar;
  }

  @override
  _JarWidgetState createState() => _JarWidgetState();
}

class _JarWidgetState extends State<JarWidget> {

  AnimationController animationController;
  Animation<double> animation;





  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAccept: (data) {
        return isToday;
      },
      onAccept: (Coin data) {
        if (!this.widget._jar.coins.contains(data)) {
          setState(() {
            // this.widget._jar.coins.add(data);
            globals.days.days[DateFormat("yMd").format(selectedDate)].coinsInJar
                .add(data);
            globals
                .days.days[DateFormat("yMd").format(selectedDate)].pendingCoins
                .remove(data);

            globals.days.saveLocally();
          });
        }
      },
      builder: (context, Coin, List) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: this.widget._jar.day.complete() ?  
             
              Container(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 90),child: ScaleAnimation(),) 
            
            
            : Container(),
            ),
            new SvgPicture.asset('assets/images/jar.svg',
                semanticsLabel: 'Jar'),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              //color: Colors.white.withOpacity(1),
              //decoration: BoxDecoration(
              //  image: DecorationImage(
              //    image: AssetImage("assets/images/jar.png"),
              //    fit: BoxFit.cover,
              //  ),
              //),
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.spaceEvenly,
                  verticalDirection: VerticalDirection.up,
                  children: this
                      .widget
                      ._jar
                      .coins
                      .map(
                        (coin) => new GestureDetector(
                            onVerticalDragEnd: (dir) {
                              if (isToday &&
                                  dir.velocity.pixelsPerSecond.direction < 0) {
                                setState(() {
                                  _coinRowStateKey.currentState.addCoin(coin);
                                  this.widget._jar.coins.remove(coin);
                                  globals.days.saveLocally();
                                });
                              }
                            },
                            onLongPress: () {
                              if (isToday) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: Text("Remove HabitCoin?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            print('Removing ' + coin.Name);
                                            setState(() {
                                              _coinRowStateKey.currentState
                                                  .addCoin(coin);
                                              this
                                                  .widget
                                                  ._jar
                                                  .coins
                                                  .remove(coin);
                                              globals.days.saveLocally();
                                            });

                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                      content: Text(
                                          "Do you want to remove this HabitCoin from the jar?"),
                                    );
                                  },
                                );
                              }
                            },
                            child: new Container(
                              margin: EdgeInsets.all(3),
                              width: 65.0,
                              height: 65.0,
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
                                  size: 30,
                                ),
                              ),
                            )),
                      )
                      .toList()),
            ),
          ],
        );
      },
    );
  }
}

class CoinRow extends StatefulWidget {
  @override
  _CoinRowState createState() => _CoinRowState();

  final List<Coin> coins;

  const CoinRow(Key key, this.coins) : super(key: key);
}

class _CoinRowState extends State<CoinRow> {
  void addCoin(Coin coin) {
    setState(() {
      this.widget.coins.insert(0, coin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: this
            .widget
            .coins
            .map((coin) => LongPressDraggable(
                  hapticFeedbackOnStart: true,
                  maxSimultaneousDrags: isToday ? 1 : 0,
                  onDragCompleted: () {
                    setState(() {
                      //this.widget.coins.remove(coin);
                    });
                  },
                  data: coin,

                  // axis: Axis.vertical,
                  child: Container(
                    margin: EdgeInsets.all(6),
                    width: 110.0,
                    height: 110.0,
                    decoration: new BoxDecoration(
                      color: isToday
                          ? Colors.white
                          : Colors.black.withOpacity(0.01),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        coin.Icon,
                        size: 44,
                      ),),
                    ),
                  
                  feedback: Container(
                    margin: EdgeInsets.all(6),
                    width: 120.0,
                    height: 120.0,
                    decoration: new BoxDecoration(
                      color: Colors.white.withOpacity(.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        coin.Icon,
                        size: 44,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    margin: EdgeInsets.all(6),
                    width: 110.0,
                    height: 110.0,
                    decoration: new BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        coin.Icon,
                        size: 44,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),)
            .toList(),
      ),
    );
  }
}
