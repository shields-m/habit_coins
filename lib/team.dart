import 'package:flutter/material.dart';

class Team extends StatefulWidget {
  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    return
        Container(

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
                  title: Text('Mark Shields', style: TextStyle(fontSize: 20,)),
                  subtitle: Text('Team Leader'),
                  trailing: Icon(Icons.account_circle),
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
                  title: Text('John Durkin', style: TextStyle(fontSize: 20,),),
                  subtitle: Text('Team Member'),
                  trailing: Icon(Icons.account_box),
                ),
              ),
              //Padding(padding: EdgeInsets.symmetric(vertical: 10),),
            ],
          ),
        );

  }
}
