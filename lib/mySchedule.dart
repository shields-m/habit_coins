import 'package:flutter/material.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/addCoin.dart';
import 'package:habit_coins/globals.dart' as globals;

import 'localData.dart';

class MySchedule extends StatefulWidget {
  @override
  _MyScheduleState createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  @override
  Widget build(BuildContext context) {
    List<Container> allCoins = new List();
    globals.mainSchedule.Items.forEach((item) => {
          allCoins.add(Container(
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
              title: Text(item.HabitCoin.Name,
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text(item.DaysOfWeek.toString()
                  .replaceAll('[', '')
                  .replaceAll(']', '')),
              trailing: Icon(item.HabitCoin.Icon),
              onTap: () {
                openExistingCoinScreen(item);
              },
            ),
          ))
        });

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
            Container(
              padding: const EdgeInsets.all(6.0),
              child: Text('HabitCoins'),
            )
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
                  'My HabitCoins',
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
                title: Text('Add New HabitCoin',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                subtitle: Text('Tap here to create a new HabitCoin'),
                trailing: Icon(Icons.add),
                onTap: () {
                  openNewCoinScreen();
                },
              ),
            ),
            Column(
              children: allCoins,
            ),
            //Padding(padding: EdgeInsets.symmetric(vertical: 10),),
    //         flatbutton(child: text('hello'),
    //         onpressed: (){
    //            loadschedule().then((s) {
    //   setstate(() {
    //     globals.mainschedule = s;
    //     showdialog(
    //                             context: context,
    //                             builder: (buildcontext context) {
    //                               // return object of type dialog
    //                               return alertdialog(
    //                                 title: text("?"),
    //                                 actions: <widget>[
    //                                   flatbutton(
    //                                     child: text("no"),
    //                                     onpressed: () {
    //                                       navigator.pop(context);
    //                                     },
    //                                   ),
    //                                   flatbutton(
    //                                     child: text("yes"),
    //                                     onpressed: () {
                                          

                                          
    //                                     },
    //                                   )
    //                                 ],
    //                                 content: text(
    //                                     globals.mainschedule.prt()
    //                                     ),);
    //                             },
    //                           );
    //   });
    // });
                


    //         },)
          ],
        ),
      ),
    );
  }

  void openNewCoinScreen() async {
    final AddCoin page = new AddCoin();
    final ScheduleItem newCoin = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    if (newCoin != null) {
      setState(() {
        DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
        String formattedDate = DateFormat("yMd").format(today);
        globals.mainSchedule.AddItem(newCoin);
        if(newCoin.DaysOfWeek.contains(DateFormat('EEEE').format(today))){
        globals
                .days.days[formattedDate].pendingCoins.add(newCoin.HabitCoin);
        }

        globals.mainSchedule.saveLocally();
        globals.days.saveLocally();
      });
    }
  }

  void openExistingCoinScreen(ScheduleItem s) async {
    final AddCoin page = new AddCoin.fromExisting(s);
    final ScheduleItem newCoin = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
    if (newCoin != null) {
      setState(() {
        DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
        String formattedDate = DateFormat("yMd").format(today);
        if (newCoin.Delete) {
          globals.mainSchedule.RemoveItem(s);
          globals
                .days.days[formattedDate].pendingCoins.remove(s.HabitCoin);
          
        } else {
          globals
                .days.days[formattedDate].pendingCoins.remove(s.HabitCoin);
          s.DaysOfWeek = newCoin.DaysOfWeek;
          s.HabitCoin = newCoin.HabitCoin;
if(newCoin.DaysOfWeek.contains(DateFormat('EEEE').format(today))){
          globals
                .days.days[formattedDate].pendingCoins.add(newCoin.HabitCoin);
}

        }

        //globals.mainSchedule.AddItem(newCoin);
      });

      globals.mainSchedule.saveLocally();
      globals.days.saveLocally();
    }
    
  }
}
