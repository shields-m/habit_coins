import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habit_coins/main.dart';
import 'package:habit_coins/onboarding.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:intl/intl.dart';

import 'localData.dart';
import 'models.dart';

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
    loadOnboardStatus().then((x) {
      
      //doIKnowIfOnboardingIsComplete = true;
      onboardingComplete = x;
      if (onboardingComplete) {
        //print('onboarding complete');
        loadSchedule().then((s) {
          
          globals.mainSchedule = s;
          globals.ScheduleLoaded = true;
          loadDays().then((d) {
            globals.days = d;
            globals.DaysLoaded = true;
          DateTime selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
            if (!globals.days.days
                .containsKey(DateFormat("yMd").format(selectedDate))) {

                  Day today = new Day();


              today.coinsInJar = new List<Coin>();

              today.pendingCoins = globals.mainSchedule.getCoinsForDay(selectedDate);
              globals.days.days[DateFormat("yMd").format(selectedDate)] = today;
              
            } 

            
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'HabitCoins',)));
             //MyHomePage home = new MyHomePage(title: 'HabitCoins');
            //  Navigator.pushAndRemoveUntil(
            //      context,
            //      MaterialPageRoute(
            //        builder: (BuildContext context) => home,
            //      ),
            //      ModalRoute.withName('/'));
          });
        });
      } else {
        print('onboarding not complete');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingPage()));
      }
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
          Text(
            'HabitCoins',
            style: TextStyle(color: Colors.white, fontSize: 48),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
          CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
