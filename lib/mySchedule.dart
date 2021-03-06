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
        DateTime today = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        String month = DateFormat("LLL yyyy").format(today);
        String formattedDate = globals.getDayKey(today);
        if (globals.UseCloudSync) {
          addCoinToCloud(newCoin).then((id) {
            newCoin.HabitCoin.CloudID = id;
          });
        }
        globals.mainSchedule.AddItem(newCoin);
        if (newCoin.DaysOfWeek.contains(DateFormat('EEEE').format(today))) {
          globals.days.days[formattedDate].pendingCoins.add(newCoin.HabitCoin);
          if (globals.monthsList.Months.containsKey(month)) {
            globals.monthsList.Months[month].DaysCompleted
                .remove(formattedDate);
          }
          if (globals.UseCloudSync) {
            saveTodayToCloud();

            globals.monthsList.saveLocally();
          }
        }
        print(newCoin.HabitCoin.CloudID);
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
        DateTime today = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        String month = DateFormat("LLL yyyy").format(today);
        String formattedDate = globals.getDayKey(today);
        if (newCoin.Delete) {
          globals.mainSchedule.RemoveItem(s);
          globals.days.days[formattedDate].pendingCoins.remove(s.HabitCoin);
          if (globals.UseCloudSync) {
            deleteCoinFromCloud(s.HabitCoin.CloudID);
            saveTodayToCloud();
            if (globals.monthsList.Months.containsKey(month)) {
              globals.monthsList.Months[month].DaysCompleted
                  .remove(formattedDate);

              if (globals.days.days[formattedDate].complete()) {
                globals.monthsList.Months[month].DaysCompleted
                    .add(formattedDate);
              }

              globals.monthsList.saveLocally();
            }
          }
        } else {
          globals.days.days[formattedDate].pendingCoins.remove(s.HabitCoin);
          s.DaysOfWeek = newCoin.DaysOfWeek;
          s.HabitCoin = newCoin.HabitCoin;
          if (newCoin.DaysOfWeek.contains(DateFormat('EEEE').format(today))) {
            globals.days.days[formattedDate].pendingCoins
                .add(newCoin.HabitCoin);
          }
          if (globals.UseCloudSync) {
            updateCoinInCloud(s);

            saveTodayToCloud();
            if (globals.monthsList.Months.containsKey(month)) {
              globals.monthsList.Months[month].DaysCompleted
                  .remove(formattedDate);
              if (globals.days.days[formattedDate].complete()) {
                globals.monthsList.Months[month].DaysCompleted
                    .add(formattedDate);
              }

              globals.monthsList.saveLocally();
            }
          }
        }

        //globals.mainSchedule.AddItem(newCoin);
      });

      globals.mainSchedule.saveLocally();
      globals.days.saveLocally();
    }
  }
}
