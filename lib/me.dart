import 'package:flutter/material.dart';
import 'package:habit_coins/mySchedule.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:habit_coins/globals.dart' as globals;

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return
        Container(
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
                  title: Text('My Name', style: TextStyle(fontSize: 20,)),
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
                  title: Text('My HabitCoins', style: TextStyle(fontSize: 20,),),
                  subtitle: Text('Setup your HabitCoins'),
                  trailing: Icon(Icons.toll),
                ),
              ),
              //Padding(padding: EdgeInsets.symmetric(vertical: 10),),
            ],
          ),
        );
  }

    
  void openScheduleScreen() async{
final MySchedule page = new MySchedule();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page),
                    );

                    

  }


}
