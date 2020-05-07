import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habit_coins/main.dart';
import 'package:habit_coins/myCoins.dart';
import 'package:habit_coins/onboarding.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:intl/intl.dart';

import 'localData.dart';
import 'models.dart';
import 'package:habit_coins/auth/authentication.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool doIKnowIfOnboardingIsComplete = false;
  bool onboardingComplete = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = new Auth();

    loadOnboardStatus().then((x) {
      Future.delayed(Duration(seconds: 0)).then((n) {
        //doIKnowIfOnboardingIsComplete = true;
        onboardingComplete = x;
        if (onboardingComplete) {
          //print('onboarding complete');
           loadSoundSetting().then((value) => globals.playSounds = value);
          globals.ShowHelp = false;
          globals.UseCloudSync = false;
          auth.getCurrentUser().then((u) {
            if (u != null) {
              globals.CurrentUser = u.uid;
              globals.UseCloudSync = true;
              getUserDetailsForCurrentUser().then((d) {
                globals.userDetails = d;
                if (d.TeamID != 'null' && d.TeamID != '') {
                  
                    globals.myTeam = new Team();
                  
                }
              });

              loadScheduleFromCloud();
            }
          });

          loadSchedule().then((s) {
            globals.mainSchedule = s;
            globals.ScheduleLoaded = true;
            loadDays().then((d) {
              globals.days = d;
              globals.DaysLoaded = true;
              loadMonths().then((m) {
                globals.monthsList = m;
                globals.MonthsLoaded = true;
                DateTime selectedDate = DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day);
                String dateKey = globals.getDayKey(selectedDate);

                if (globals.UseCloudSync) {
                  getDayFromCloud(selectedDate).then((d) {
                    globals.days.days[dateKey] = d;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: 'HabitCoins',
                                )));
                  });
                } else {
                  if (!globals.days.days
                      .containsKey(globals.getDayKey(selectedDate))) {
                    Day today = new Day();

                    today.coinsInJar = new List<Coin>();

                    today.pendingCoins =
                        globals.mainSchedule.getCoinsForDay(selectedDate);
                    globals.days.days[dateKey] = today;
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: 'HabitCoins',
                              )));
                }
              });
            });
          });
        } else {
          print('onboarding not complete');
          globals.ShowHelp = true;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OnboardingPage()));
        }
      });
    });

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 53, 83, 165),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/unless.jpg',
              fit: BoxFit.contain,
              height: 300,
            ),
          ),
          // Text(
          //   'HabitCoins',
          //   style: TextStyle(color: Colors.white, fontSize: 48),
          // ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Image.asset(
                'assets/images/habitcoinslogo.png',
                fit: BoxFit.contain,
                height: 150,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
