import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_coins/mySchedule.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/auth/signupsignin.dart';
import 'package:habit_coins/auth/authentication.dart';
import 'package:habit_coins/globals.dart' as globals;

import 'auth/authentication.dart';

class Me extends StatefulWidget {
  BaseAuth auth = new Auth();

  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
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
              title: Text('My Name',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text('Mark Shields'),
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
            setState(() {
              this.widget.auth.signOut();
              
            });
            
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
    if (loggedin) {
      setState(() {});
    }
  }
}
