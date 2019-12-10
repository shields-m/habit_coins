import 'package:flutter/material.dart';
import 'package:habit_coins/calendar.dart';
import 'package:habit_coins/teams.dart';

class Unless extends StatefulWidget {
  @override
  _UnlessState createState() => _UnlessState();
}

class _UnlessState extends State<Unless> {
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
                'Unless',
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
              onTap: () {
                openSharedTeams();
              },
              title: Text('Shared Teams',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text('View all team that share data with Unless'),
              trailing: Icon(Icons.people_outline),
              
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
                
              },
              title: Text('Create Team',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text('Create a new team'),
              trailing: Icon(Icons.person_add),
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
                openAllTeams();
              },
              title: Text('All Teams',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              subtitle: Text('View details of all teams'),
              trailing: Icon(Icons.people),
            ),
          ),
        ],
      ),
    );
  }

  void openSharedTeams() async {
    final TeamsList page = new TeamsList('shared');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void openAllTeams() async {
    final TeamsList page = new TeamsList('all');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

}
