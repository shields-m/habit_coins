import 'package:flutter/material.dart';
import 'package:habit_coins/calendar.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                'History',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // Container(
          //   decoration: BoxDecoration(
          //     border: Border(
          //       top: BorderSide(
          //         color: Color.fromARGB(128, 53, 83, 165),
          //         width: 1,
          //       ),
          //     ),
          //     //borderRadius: BorderRadius.circular(16.0),
          //   ),
          //   child: ListTile(
          //     title: Text('Coming Soon...', style: TextStyle(fontSize: 20,)),
          //     subtitle: Text('See your history and statistics!'),
          //     trailing: Icon(Icons.av_timer),
          //   ),
          // ),
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
            child: Calendar(),
          ),
        ],
      ),
    );
  }
}
