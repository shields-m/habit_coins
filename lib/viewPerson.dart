import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_coins/calendar.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/addCoin.dart';
import 'package:habit_coins/globals.dart' as globals;

import 'localData.dart';

class ViewPerson extends StatefulWidget {
  String _id = '';

  ViewPerson(String id) {
    _id = id;
  }

  @override
  _ViewPersonState createState() => _ViewPersonState();
}

class _ViewPersonState extends State<ViewPerson> {
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  Person p;
  @override
  Widget build(BuildContext context) {
    if (!loading && !globals.people.containsKey(this.widget._id)) {
      //Load Person
      print('load person');
      loading = true;
      loadPerson(this.widget._id).then((p) {
        globals.people[this.widget._id] = p;
        setState(() {
          loading = false;
        });
      });
    } else if (!loading &&
        globals.people[this.widget._id].lastGotFromCloud
            .isBefore(DateTime.now().add(Duration(minutes: -10)))) {
      //Reload Person
      print('reload person');
      loading = true;
      loadPerson(this.widget._id).then((p) {
        globals.people[this.widget._id] = p;
        setState(() {
          loading = false;
        });
      });
    }
    if (loading) {
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
                'assets/images/habitcoinslogo.png',
                fit: BoxFit.contain,
                height: 40,
              ),
              // Container(
              //     padding: const EdgeInsets.all(6.0), child: Text(widget.title),)
            ],
          ),
        ),
        body: Container(
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
                    '',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              LinearProgressIndicator(),
            ],
          ),
        ),
      );
    }
    p = globals.people[this.widget._id];
    // print (p.schedule.Items);
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
              'assets/images/habitcoinslogo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            // Container(
            //     padding: const EdgeInsets.all(6.0), child: Text(widget.title),)
          ],
        ),
      ),
      body: Container(
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
                  p.name,
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
              ),
              margin: EdgeInsets.symmetric(
                vertical: 0,
              ),
              padding: EdgeInsets.symmetric(vertical: 10,),
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: p.schedule.Items
                    .map(
                      (coin) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
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
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(6),
                                          width: 90.0,
                                          height: 90.0,
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
                                              coin.HabitCoin.Icon,
                                              size: 36,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            coin.HabitCoin.Name,
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: Text(
                                            coin.DaysOfWeek.toString()
                                                .replaceAll('[', '')
                                                .replaceAll(']', ''),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(3),
                          width: 90.0,
                          height: 90.0,
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
                              coin.HabitCoin.Icon,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Calendar.forOtherUser(this.widget._id),
          ],
        ),
      ),
    );
  }

}