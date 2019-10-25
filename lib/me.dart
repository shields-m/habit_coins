import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_coins/myCoins.dart';
import 'package:habit_coins/mySchedule.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/auth/signupsignin.dart';
import 'package:habit_coins/auth/authentication.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:intl/intl.dart';

import 'auth/authentication.dart';
import 'localData.dart';

class Me extends StatefulWidget {
  BaseAuth auth = new Auth();
  String Name = 'Loading...';
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  void initState() {
    loadName().then((name) => {
          setState(() {
            this.widget.Name = name;
          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0.0, 0),
          )
        ],
        color: Colors.white,
        border: Border.all(
          color: Color.fromARGB(255, 53, 83, 165),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'My Details',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
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
            child: ListTile(
              onTap: () {
                editName();
              },
              title: Text('My Name',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text(this.widget.Name),
              trailing: Icon(Icons.person),
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
            child: ListTile(
              onTap: () {
                openScheduleScreen();
              },
              title: Text(
                'My HabitCoins',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Text('Setup your HabitCoins'),
              trailing: Icon(Icons.toll),
            ),
          ),
          cloudOptions(),
        ],
      ),
    );
  }

  Widget cloudOptions() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
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
              child: ListTile(
                onTap: () {
                  signOut();
                },
                title: Text(
                  'Cloud Sync',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                subtitle: Text('Sign out of cloud sync'),
                trailing: Icon(Icons.cloud_off),
              ),
            );
          }
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
            child: ListTile(
              onTap: () {
                openCloudPage();
              },
              title: Text(
                'Cloud Sync',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Text('Log in to sync your HabitCoins to the cloud'),
              trailing: Icon(Icons.cloud_queue),
            ),
          );
        });
  }

  void editName() {
    TextEditingController txtName = new TextEditingController();
    txtName.text = this.widget.Name;

    var focusNode = new FocusNode();
    var nameTextField = new TextField(
      textCapitalization: TextCapitalization.words,
      focusNode: focusNode,
      controller: txtName,
    );

    FocusScope.of(context).requestFocus(focusNode);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Enter your name"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Save"),
              onPressed: () {
                saveName(txtName.text).then((s) => {
                      setState(() {
                        this.widget.Name = txtName.text;
                      })
                    });
                Navigator.pop(context);
              },
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              nameTextField,
            ],
          ),
        );
      },
    );
  }

  void openScheduleScreen() async {
    final MySchedule page = new MySchedule();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

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

      setState(() {});
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

  void signOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Sign Out?"),
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
                  this.widget.auth.signOut();
                });
                Navigator.pop(context);
              },
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Are you seure you want to sign out of cloud sync?')
            ],
          ),
        );
      },
    );
  }
}
