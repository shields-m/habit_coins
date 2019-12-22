import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_coins/auth/authentication.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/mySchedule.dart';
import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/addCoin.dart';
import 'package:habit_coins/globals.dart' as globals;

import 'auth/signupsignin.dart';
import 'localData.dart';

class Settings extends StatefulWidget {
  BaseAuth auth = new Auth();
 String Name = 'Loading...';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);

    
    loadName().then((name) => {
          setState(() {
            this.widget.Name = name;
          })
        });

   


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              'assets/images/habitcoins ',
              fit: BoxFit.contain,
              height: 40,
            ),
            // Container(
            //     padding: const EdgeInsets.all(6.0), child: Text(widget.title),)
          ],
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          labelColor: Colors.white,
          tabs: [
            new Tab(
              icon: new Icon(Icons.person_outline),
              text: 'Me',
            ),
            new Tab(
                icon: new Icon(
                  Icons.people_outline,
                ),
                text: 'Team'),
            new Tab(
                icon: new Icon(
                  Icons.info_outline,
                ),
                text: 'About')
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          buildMeSettings(),
          buildTeamSettings(),
          buildAboutSettings(),
        ],
        controller: _tabController,
      ),
    );
  }

void sendPasswordResetEmail()
{
  this.widget.auth.sendPasswordResetEmail().then((_){
      showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Reset Password"),
          actions: <Widget>[
            
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                
                Navigator.pop(context);
              },
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('A password reset email has been sent to your email address.'),
            ],
          ),
        );
      },
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

  Widget buildMeSettings() {
    return ListView(
      children: <Widget>[
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
            color: Color.fromARGB(128, 53, 83, 165),
            
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(128, 53, 83, 165),
                width: 1,
              ),
            ),
            //borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'HabitCoins',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
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
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(128, 53, 83, 165),
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(128, 53, 83, 165),
                width: 1,
              ),
            ),
            //borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Goals & Rewards',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
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
          child: ListTile(
            onTap: () {},
            title: Text(
              'Set New Reward',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text('Setup a new reward for achieving your goals '),
            trailing: Icon(Icons.star_border),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(128, 53, 83, 165),
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(128, 53, 83, 165),
                width: 1,
              ),
            ),
            //borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Cloud Sync',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        cloudOptions(),
        globals.UseCloudSync
            ? Container(
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
                    sendPasswordResetEmail();
                  },
                  title: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text('Update my Cloud Sync password'),
                  trailing: Icon(Icons.lock_outline),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
              ),
        globals.UseCloudSync
            ? Container(
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
                  onTap: () {},
                  title: Text(
                    'Delete Cloud Sync Data',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text('Remove all of my data from the cloud'),
                  trailing: Icon(Icons.delete_forever),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
              ),
      ],
    );
  }

   void openScheduleScreen() async {
    final MySchedule page = new MySchedule();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
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

  void openCloudPage() async {
    String name = await loadName();
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
                      saveScheduleToCloud().then((_) {
                        saveAllDaysToCloud().then((_) {
                          saveAlltMonthsToCloud().then((_) {
                            Navigator.pop(context);
                          });
                        });
                      });
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
          createUserInCloud(globals.CurrentUser, name).then((e) {
            saveScheduleToCloud().then((_) {
              saveAllDaysToCloud().then((_) {
                saveAlltMonthsToCloud().then((_) {});
              });
            });
          });
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

  Widget buildAboutSettings() {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: Image.asset('assets/images/habitcoinslogo.png'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                child: Text(
                  '2019-2020 Unless Coaching Ltd.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 30),
                child: Image.asset('assets/images/unless.jpg'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildTeamSettings() {
    String TeamName = '';
    if (globals.UseCloudSync) {
      if (globals.userDetails.TeamID != null &&
          globals.userDetails.TeamID.trim() != '') {
        if (globals.myTeam.Name == null) {
          loadTeamFromCloud().then((t) {
            setState(() {
              globals.myTeam = t;
            });
          });
        } else {
          TeamName = globals.myTeam.Name;
        }
        return ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(128, 53, 83, 165),
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(128, 53, 83, 165),
                    width: 1,
                  ),
                ),
                //borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Team Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
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
              child: ListTile(
                title: Text(TeamName,
                    style: TextStyle(
                      fontSize: 20,
                    )),
                subtitle: Text(globals.userDetails.TeamID),
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
                title: Text('Share with Unless?',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                subtitle: Text(
                    'Would you like to share your HabitCoins with Unless?'),
                trailing: Switch(
                  value: globals.userDetails.shareWithUnless &&
                      globals.myTeam.shareWithUnless,
                  onChanged: globals.myTeam.shareWithUnless
                      ? (value) {
                          setShareWithUnlessForCurrentUser(value).then((_) {
                            setState(() {
                              globals.userDetails.shareWithUnless = value;
                            });
                          });
                        }
                      : (value) {
                          Fluttertoast.showToast(
                              msg: "Your team does not share data with Unless.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.black.withOpacity(0.8),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                  activeTrackColor: Color.fromARGB(128, 53, 83, 165),
                  activeColor: Color.fromARGB(255, 53, 83, 165),
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
                title: Text('Leave Team',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                subtitle: Text('Stop sharing your HabitCoins with the team'),
                trailing: Icon(Icons.directions_run),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: Text("Leave Team?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              leaveTeam(globals.userDetails.TeamID).then((_) {
                                Navigator.pop(context);
                                setState(() {
                                  globals.userDetails.TeamID = '';
                                });
                              });
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Are you sure you want to leave this team?')
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return Center(
          child: Text('You are not currently a member of a team.'),
        );
      }
    } else {
      return Center(
        child: Text('You must use Cloud Sync before you can join a team'),
      );
    }
  }
}
