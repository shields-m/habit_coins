import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:habit_coins/teammembers.dart';
import 'package:intl/intl.dart';
import 'package:habit_coins/addCoin.dart';
import 'package:habit_coins/globals.dart' as globals;

import 'localData.dart';

class TeamsList extends StatefulWidget {
  String mode = '';

  TeamsList(String viewMode) {
    mode = viewMode;
  }

  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {
  @override
  Widget build(BuildContext context) {
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
        child: StreamBuilder<QuerySnapshot>(
          stream: this.widget.mode == 'shared' ? Firestore.instance
              .collection('teams')
              .where('shareWithUnless', isEqualTo: true)
              .snapshots() : Firestore.instance
              .collection('teams')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text(
                      this.widget.mode == 'all' ? 'All Teams' : 'Shared Teams',
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                _buildList(context, snapshot.data.documents),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    return Container(
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
        title: Text(data.data['teamName'],
            style: TextStyle(
              fontSize: 20,
            )),
        subtitle: Text(data.documentID),
        trailing: Icon(Icons.people_outline),
        onTap: () {
 
    final TeamMembers page = new TeamMembers(data.documentID,data.data['teamName'].toString(),this.widget.mode);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  

        },
      ),
    );
  }

   
}
