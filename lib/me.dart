import 'package:flutter/material.dart';
import 'package:habit_coins/addCoin.dart';

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCoin()),
                    );
                  },
                  title: Text('My Coins', style: TextStyle(fontSize: 20,),),
                  subtitle: Text('Setup your HabitCoins'),
                ),
              ),
              //Padding(padding: EdgeInsets.symmetric(vertical: 10),),
            ],
          ),
        );
  }
}
