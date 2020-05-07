import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:habit_coins/localData.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_container/overlay_container.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

GlobalKey<_CoinRowState> _coinRowStateKey = GlobalKey();
DateTime selectedDate;
bool isFuture;
bool isToday;
bool isPast;
AudioCache player = AudioCache(prefix: 'audio/');
DateTime _currentMonth;
String _currentMonthName;
Random rand;


class MyCoins extends StatefulWidget {
  // bool ShowHelp;
  

  final Function function;

  MyCoins({Key key, this.function}) : super(key: key) {
    //ShowHelp = false;
    
    rand = new Random();
    selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    isFuture = false;
    isToday = true;
    isPast = false;

    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _currentMonthName = new DateFormat("LLL yyyy").format(_currentMonth);
  }
  Jar jar = new Jar.fromDay(globals.days.days[globals.getDayKey(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day))]);

  MyCoinsState createState() => MyCoinsState();
}

class MyCoinsState extends State<MyCoins> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // fileWriter w = new fileWriter();
    //w.saveFile(this.widget._coins);
    List<Coin> coins;

    if (globals.ScheduleLoaded && globals.DaysLoaded) {
      if (isFuture) {
        coins = globals.mainSchedule.getCoinsForDay(selectedDate);
      } else {
        coins = globals.days.days[globals.getDayKey(selectedDate)].pendingCoins;
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
                  child: Container(
                    margin: EdgeInsets.all(3),
                    width: 45.0,
                    height: 45.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                
                new GestureDetector(
                  onTap: () {
                    _selectDate();
                  },
                  child: Column(
                    children:<Widget>[
                      OverlayContainer(
                  show: globals.ShowHelp ,
                  // Let's position this overlay to the right of the button.
                  position: OverlayContainerPosition(-100, 0),
                  // The content inside the overlay.
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 53, 83, 165),
                        width: 1,
                      ),
                      borderRadius: new BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color.fromARGB(128, 53, 83, 165),
                          blurRadius: 2,
                          spreadRadius: 4,
                        )
                      ],
                    ),
                    child: Text(
                        "Use the left and right arrown\nto move through the dates."),
                  ),
                ),
                    new Text(
                    new DateFormat("E dd LLL yyyy").format(selectedDate),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),],),
                ),
                new GestureDetector(
                  onTap: () {
                    setDate(selectedDate.add(new Duration(hours: 26)));
                  },
                  child: Container(
                    margin: EdgeInsets.all(3),
                    width: 45.0,
                    height: 45.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.help_outline),
          //   onPressed: () {
          //     setState(() {
          //       globals.ShowHelp = !globals.ShowHelp;
          //     });
          //   },
          // ),
          CoinRow(
            _coinRowStateKey,
            coins,
          ),
          OverlayContainer(
            show: globals.ShowHelp,
            // Let's position this overlay to the right of the button.
            position: OverlayContainerPosition(
              // Left position.
              120,
              // Bottom position.
              110,
            ),
            // The content inside the overlay.
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 53, 83, 165),
                  width: 1,
                ),
                borderRadius: new BorderRadius.all(
                  Radius.circular(8),
                ),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromARGB(128, 53, 83, 165),
                    blurRadius: 2,
                    spreadRadius: 4,
                  )
                ],
              ),
              child: Text(
                  "Press and hold a HabitCoin\nto pick it up. Scroll left and\nright to see all of your HabitCoins."),
            ),
          ),
          new Expanded(child: new JarWidget(this.widget.jar)),
        ],
      );
    } else {
      // loadschedule().then((s) {
      //   loaddays().then((d) {
      //     setstate(() {
      //       day today = new day();
      //       globals.days = d;
      //       if (!globals.days.days
      //           .containskey(globals.getdaykey(selecteddate))) {
      //         today.coinsinjar = new list<coin>();

      //         today.pendingcoins = s.getcoinsforday(selecteddate);
      //         globals.days.days[globals.getdaykey(selecteddate)] = today;
      //       } else {
      //         today = globals.days.days[globals.getdaykey(selecteddate)];
      //       }
      //       this.widget.jar = new jar.fromday(today);
      //       globals.mainschedule = s;

      //       //print(json.encode(globals.days));
      //     });
      //   });
      // });
      return LinearProgressIndicator();
    }
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(9999));
    if (picked != null) setDate(picked);
  }

  Future<void> setDate(DateTime dateTime) async {
    DateTime newDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (newDate.isBefore(now.add(Duration(days: -30)))) {
      Fluttertoast.showToast(
          msg: "You can only go back 30 days in this view",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (newDate.isAfter(now.add(Duration(days: 15)))) {
      Fluttertoast.showToast(
          msg: "You can only go forward two weeks in this view",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      selectedDate = newDate;
      String dateKey = globals.getDayKey(newDate);
      Jar jar;
      if (newDate.isAtSameMomentAs(now)) {
        isToday = true;
        isFuture = false;
        isPast = false;
        if (!globals.days.days.containsKey(dateKey)) {
          if (globals.UseCloudSync) {
            globals.days.days[dateKey] = await getDayFromCloud(newDate);
          } else {
            Day today = new Day();
            today.coinsInJar = new List<Coin>();

            today.pendingCoins = globals.mainSchedule.getCoinsForDay(newDate);
            globals.days.days[dateKey] = today;
          }
        } else {
          if (globals.UseCloudSync &&
              globals.days.days[dateKey].lastGotFromCloud
                  .isBefore(DateTime.now().add(Duration(minutes: -10)))) {
            //get from cloud if it is more than 10 minutes old
            globals.days.days[dateKey] = await getDayFromCloud(newDate);
          }
        }
        jar = new Jar.fromDay(globals.days.days[dateKey]);
      } else if (newDate.isAfter(now)) {
        isToday = false;
        isFuture = true;
        isPast = false;
        jar = new Jar();
      } else if (newDate.isBefore(now)) {
        isToday = false;
        isFuture = false;
        isPast = true;

        if (!globals.days.days.containsKey(dateKey)) {
          if (globals.UseCloudSync) {
            globals.days.days[dateKey] = await getDayFromCloud(newDate);
          } else {
            Day today = new Day();
            today.coinsInJar = new List<Coin>();

            today.pendingCoins = globals.mainSchedule.getCoinsForDay(newDate);
            globals.days.days[dateKey] = today;
          }
        } else {
          if (globals.UseCloudSync &&
              globals.days.days[dateKey].lastGotFromCloud
                  .isBefore(DateTime.now().add(Duration(days: -1)))) {
            //get from cloud if it is more than 1 day old
            globals.days.days[dateKey] = await getDayFromCloud(newDate);
          }
        }
        jar = new Jar.fromDay(globals.days.days[dateKey]);
      }

      setState(() {
        this.widget.jar = jar;
      });
    }
    //print(json.encode(globals.days));
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
           if(globals.playSounds){
player.play('Coin' + (rand.nextInt(2) + 1).toString() + '.mp3');
           }
    
          setState(() {
            String dt = globals.getDayKey(selectedDate);
            // this.widget._jar.coins.add(data);
            globals.days.days[dt].coinsInJar.add(data);
            globals.days.days[dt].pendingCoins.remove(data);

            if (!globals.monthsList.Months.containsKey(_currentMonthName)) {
              globals.monthsList.Months[_currentMonthName] =
                  new Month(_currentMonthName);
            }
            if (globals.days.days[dt].complete()) {
              globals.monthsList.Months[_currentMonthName].DaysCompleted
                  .add(dt);
              globals.monthsList.saveLocally();
            }

            globals.days.saveLocally();
          });
        }
      },
      builder: (context, Coin, List) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            OverlayContainer(
              show: globals.ShowHelp && this.widget._jar.coins.length > 0,
              // Let's position this overlay to the right of the button.
              position: OverlayContainerPosition(10, 1),
              // The content inside the overlay.
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 53, 83, 165),
                    width: 1,
                  ),
                  borderRadius: new BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromARGB(128, 53, 83, 165),
                      blurRadius: 2,
                      spreadRadius: 4,
                    )
                  ],
                ),
                child:
                    Text("Swipe up on any HabitCoin\nin the jar to remove it."),
              ),
            ),
            Container(
              child: this.widget._jar.day.complete()
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 90),
                      child: ScaleAnimation(),
                    )
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
                                  String dt = globals.getDayKey(selectedDate);
                                  bool alreadyComplete =
                                      globals.days.days[dt].complete();

                                  _coinRowStateKey.currentState.addCoin(coin);
                                  this.widget._jar.coins.remove(coin);

                                  if (alreadyComplete &&
                                      !globals.days.days[dt].complete()) {
                                    while (globals.monthsList
                                        .Months[_currentMonthName].DaysCompleted
                                        .remove(dt)) {}
                                    globals.monthsList.saveLocally();
                                  }
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
                                            setState(() {
                                              String dt = globals
                                                  .getDayKey(selectedDate);
                                              bool alreadyComplete = globals
                                                  .days.days[dt]
                                                  .complete();

                                              _coinRowStateKey.currentState
                                                  .addCoin(coin);
                                              this
                                                  .widget
                                                  ._jar
                                                  .coins
                                                  .remove(coin);

                                              if (alreadyComplete &&
                                                  !globals.days.days[dt]
                                                      .complete()) {
                                                while (globals
                                                    .monthsList
                                                    .Months[_currentMonthName]
                                                    .DaysCompleted
                                                    .remove(dt)) {}
                                                globals.monthsList
                                                    .saveLocally();
                                              }
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
            .map(
              (coin) => LongPressDraggable(
                
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
                    color:
                        isToday ? Colors.white : Colors.black.withOpacity(0.01),
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

                feedback: Column(
                  children: <Widget>[
                    OverlayContainer(
                      show: globals.ShowHelp,
                      // Let's position this overlay to the right of the button.
                      position: OverlayContainerPosition(20, 1),
                      // The content inside the overlay.
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 53, 83, 165),
                            width: 1,
                          ),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color.fromARGB(128, 53, 83, 165),
                              blurRadius: 2,
                              spreadRadius: 4,
                            )
                          ],
                        ),
                        child: Text(
                            "Drop the HabitCoin into the jar\nto mark it as complete."),
                      ),
                    ),
                    Container(
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
                  ],
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
              ),
            )
            .toList(),
      ),
    );
  }
}
