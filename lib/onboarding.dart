import 'package:flutter/material.dart';
import 'package:habit_coins/localData.dart';
import 'package:habit_coins/main.dart';
import 'package:habit_coins/schedule.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:intl/intl.dart';

import 'auth/authentication.dart';
import 'auth/signupsignin.dart';
import 'iconPicker.dart';
import 'icons.dart';
import 'models.dart';

TextEditingController txtName = new TextEditingController();
TextEditingController txtCoinName = new TextEditingController();
Schedule schedule = new Schedule();
Coin coin = new Coin('', IconData(0));
List<String> daysOfWeek = new List();
bool LoggedIn = false;

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<Widget> _children;

  @override
  initState() {
    super.initState();
    _children = [
      buildWelcome(),
      buildEnterName(),
      buildFirstHabitCoin(),
      buildDaysOfWeek(),
      buildCloudSync()
    ];
  }

  int _currentIndex = 0;

  Widget buildWelcome() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromARGB(255, 53, 83, 165),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0.0, 0),
          )
        ],
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'Welcome to\nHabitCoins',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(128, 53, 83, 165),
                  width: 1,
                ),
              ),
              //borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Text(
                    'This is HabitCoins from Unless Coaching, the app for helping you form new habits by giving you a quick and easy way to track your achievements each day. Follow through the next few steps to get set up and begin creating new positive habits.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 22,
                    )),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: RaisedButton(
                child: Text(
                  "Let's Begin",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget buildEnterName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromARGB(255, 53, 83, 165),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0.0, 0),
          )
        ],
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'Your Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(128, 53, 83, 165),
                  width: 1,
                ),
              ),
              //borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Text(
                  'Please Enter Your Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: txtName,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: RaisedButton(
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget buildFirstHabitCoin() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromARGB(255, 53, 83, 165),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0.0, 0),
          )
        ],
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'Your First HabitCoin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          FirstCoinBuilder(),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: RaisedButton(
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    coin.Name = txtCoinName.text;
                    print(coin.Name);
                    _currentIndex = 3;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget buildDaysOfWeek() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromARGB(255, 53, 83, 165),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0.0, 0),
          )
        ],
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'Days Of Week',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(128, 53, 83, 165),
                  width: 1,
                ),
              ),
              //borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: selectWeekDays(),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: RaisedButton(
                child: Text(
                  "One More Step",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    schedule = new Schedule();
                    ScheduleItem si = new ScheduleItem();
                    si.DaysOfWeek = getSortedWeekDays(daysOfWeek);
                    si.FirstDate = DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day);
                    si.LastDate = DateTime(9999);
                    si.HabitCoin = coin;
                    schedule.AddItem(si);
                    globals.mainSchedule = schedule;
                    print(schedule.toJson().toString());
                    _currentIndex = 4;
                  });
                },
              )),
        ],
      ),
    );
  }

  List<String> getSortedWeekDays(List<String> days) {
    List<String> newList = new List();

    if (days.contains('Monday')) {
      newList.add('Monday');
    }
    if (days.contains('Tuesday')) {
      newList.add('Tuesday');
    }
    if (days.contains('Wednesday')) {
      newList.add('Wednesday');
    }
    if (days.contains('Thursday')) {
      newList.add('Thursday');
    }
    if (days.contains('Friday')) {
      newList.add('Friday');
    }
    if (days.contains('Saturday')) {
      newList.add('Saturday');
    }
    if (days.contains('Sunday')) {
      newList.add('Sunday');
    }

    return newList;
  }

  Widget buildCloudSync() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromARGB(255, 53, 83, 165),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0.0, 0),
          )
        ],
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'Cloud Sync',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(128, 53, 83, 165),
                  width: 1,
                ),
              ),
              //borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CloudSync(),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: RaisedButton(
                child: Text(
                  "Finish",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  saveName(txtName.text);
                  if (!LoggedIn) {
                    saveSchedule(schedule);
                  

                  saveOnboardingComplete();

                  globals.ScheduleLoaded = true;
                  globals.days = new DayList();
                  globals.DaysLoaded = true;
                  Day today = new Day();
                  DateTime selectedDate = DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day);

                  today.coinsInJar = new List<Coin>();

                  today.pendingCoins =
                      globals.mainSchedule.getCoinsForDay(selectedDate);
                  globals.days.days[globals.getDayKey(selectedDate)] = today;

                  }
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyHomePage(
                          title: 'HabitCoins',
                        ),
                      ),
                      ModalRoute.withName('/'));
                },
              )),
        ],
      ),
    );
  }

  // Navigator.pushAndRemoveUntil(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (BuildContext context) => MyHomePage(title: 'HabitCoins',),
  //                   ),
  //                   ModalRoute.withName('/'));

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/unless.jpg',
              fit: BoxFit.contain,
              height: 100,
            ),
            Image.asset(
              'assets/images/habitcoins logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            // Container(
            //     padding: const EdgeInsets.all(6.0), child: Text(widget.title),)
          ],
        ),
      ),
      body: _children[_currentIndex],
    );
  }
}

class FirstCoinBuilder extends StatefulWidget {
  @override
  _FirstCoinBuilderState createState() => _FirstCoinBuilderState();
}

class _FirstCoinBuilderState extends State<FirstCoinBuilder> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(128, 53, 83, 165),
            width: 1,
          ),
        ),
        //borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(6),
            width: 110.0,
            height: 110.0,
            decoration: new BoxDecoration(
              color: Colors.white,
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
          Text(
            'Give it a name',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          TextField(
            textCapitalization: TextCapitalization.words,
            controller: txtCoinName,
            style: TextStyle(
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Select an icon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          FlatButton(
            child: Text(
              'Select Icon',
              style: TextStyle(
                  color: Color.fromARGB(255, 53, 83, 165),
                  decoration: TextDecoration.underline,
                  fontSize: 24),
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              selectIcon(context).then((newIcon) {
                if (newIcon != null) {
                  setState(() {
                    print(newIcon);
                    coin.Icon = newIcon;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class selectWeekDays extends StatefulWidget {
  @override
  _selectWeekDaysState createState() => _selectWeekDaysState();
}

class _selectWeekDaysState extends State<selectWeekDays> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Text(
          'Select the days you would like to complete your new HabitCoin',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        CheckboxListTile(
          title: const Text('Monday'),
          value: daysOfWeek.contains('Monday'),
          onChanged: (bool value) {
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              if (value) {
                daysOfWeek.add('Monday');
              } else {
                daysOfWeek.remove('Monday');
              }
              //this.widget.Days.add('Monday');
              //print(this.widget.Days);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Tuesday'),
          value: daysOfWeek.contains('Tuesday'),
          onChanged: (bool value) {
            setState(() {
              FocusScope.of(context).requestFocus(new FocusNode());
              if (value) {
                daysOfWeek.add('Tuesday');
              } else {
                daysOfWeek.remove('Tuesday');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Wednesday'),
          value: daysOfWeek.contains('Wednesday'),
          onChanged: (bool value) {
            setState(() {
              FocusScope.of(context).requestFocus(new FocusNode());
              if (value) {
                daysOfWeek.add('Wednesday');
              } else {
                daysOfWeek.remove('Wednesday');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Thursday'),
          value: daysOfWeek.contains('Thursday'),
          onChanged: (bool value) {
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              if (value) {
                daysOfWeek.add('Thursday');
              } else {
                daysOfWeek.remove('Thursday');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Friday'),
          value: daysOfWeek.contains('Friday'),
          onChanged: (bool value) {
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              if (value) {
                daysOfWeek.add('Friday');
              } else {
                daysOfWeek.remove('Friday');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Saturday'),
          value: daysOfWeek.contains('Saturday'),
          onChanged: (bool value) {
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              if (value) {
                daysOfWeek.add('Saturday');
              } else {
                daysOfWeek.remove('Saturday');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Sunday'),
          value: daysOfWeek.contains('Sunday'),
          onChanged: (bool value) {
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() {
              if (value) {
                daysOfWeek.add('Sunday');
              } else {
                daysOfWeek.remove('Sunday');
              }
            });
          },
        ),
      ],
    );
  }
}

class CloudSync extends StatefulWidget {
  @override
  _CloudSyncState createState() => _CloudSyncState();
}

class _CloudSyncState extends State<CloudSync> {
  void openCloudPage() async {
    final LoginSignUpPage page = new LoginSignUpPage(auth: new Auth());
    bool loggedin = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    if (loggedin != null && loggedin) {
      userExists().then((e) {
        if (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Select Data?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("This Device"),
                    onPressed: () {
                      saveScheduleToCloud();
                      saveAllDaysToCloud();
                      saveAlltMonthsToCloud();
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Cloud Data"),
                    onPressed: () {
                      sortOutCloud().then((_) {
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                        'You already have cloud data synced, would you like to keep the data from this device or the data in the cloud? This choice cannot be undone.')
                  ],
                ),
              );
            },
          );
        } else {
          saveScheduleToCloud();
          saveAllDaysToCloud();
          saveAlltMonthsToCloud();
        }
      });
      setState(() {
        LoggedIn = true;
      });
    }
  }

  Future<bool> sortOutCloud() async {
    DateTime selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    String month = DateFormat("LLL yyyy").format(selectedDate);
    await loadScheduleFromCloud();
    globals.monthsList = new MonthsList();

    globals.monthsList.Months[month] = await getMonthFromCloud(month);
    globals.monthsList.saveLocally();

    globals.days = new DayList();

    String dateKey = globals.getDayKey(selectedDate);

    globals.days.days[dateKey] = await getDayFromCloud(selectedDate);
    globals.days.saveLocally();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    print(LoggedIn.toString());
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        Icon(
          Icons.cloud_queue,
          size: 65,
          color: Color.fromARGB(255, 53, 83, 165),
        ),
        Text(
          'You can log into cloud sync to save your HabitCoins online to share across devices or with your team',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        LoggedIn
            ? Icon(Icons.cloud_done, color: Colors.green, size: 64)
            : FlatButton(
                child: Text(
                  'Log into cloud sync',
                  style: TextStyle(
                      color: Color.fromARGB(255, 53, 83, 165),
                      decoration: TextDecoration.underline,
                      fontSize: 24),
                ),
                onPressed: () {
                  openCloudPage();
                },
              ),
      ],
    );
  }
}
