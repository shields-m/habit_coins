import 'package:flutter/material.dart';
import 'package:habit_coins/globals.dart' as globals;

class Team extends StatefulWidget {
  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
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
      child: buildTeam(),
    );
  }

  Widget buildTeam() {
    if (!globals.UseCloudSync) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
        child: Text(
          'You must have Cloud Sync enabled to use the teams function.',
          style: TextStyle(
            
            fontSize: 28,
            
          ),
          textAlign: TextAlign.center,
        ),
      ));
    } else {
      return ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(
                'My Team',
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
              title: Text('Coming Soon...',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text('Share your progress with your team!'),
              trailing: Icon(Icons.av_timer),
            ),
          ),
        ],
      );
    }
  }
}
