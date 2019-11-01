import 'package:flutter/material.dart';
import 'package:habit_coins/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'localData.dart';

TextEditingController txtJoinTeamID = new TextEditingController();

class Team extends StatefulWidget {
  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  String _error = '';
  bool _isLoading = false;
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
    print(globals.TeamID);
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
      if (globals.TeamID == '' || globals.TeamID == 'null')
        return buildJoinTeam();
      else
        return buildTeamList();
    }
  }

  Widget buildTeamList() {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String daykey = globals.getDayKey(today);
    String month = new DateFormat("LLL yyyy").format(today);

    List<Container> allMembers = new List();
    if (!_isLoading &&
        globals.myTeam.LastGotFromCloud
            .isBefore(DateTime.now().add(Duration(minutes: -10)))) {
      _isLoading = true;
      loadTeamFromCloud().then((t) {
        globals.myTeam = t;
        setState(() {
          _isLoading = false;
        });
      });
    }

    globals.myTeam.Members.forEach((id, member) {
      print(member.Name);
      allMembers.add(Container(
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
          leading: Icon(Icons.person),
          title: Text(member.Name,
              style: TextStyle(
                fontSize: 20,
              )),
          subtitle: Text(member.Role),
          trailing: member.Days.days[daykey].complete()
              ? Image.asset(
                  'assets/images/thumbsup-small.png',
                  fit: BoxFit.fitHeight,
                  height:50,
                )
              : Text(''),
          onTap: () {},
        ),
      ));
    });

    allMembers.add(Container(
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
        title: Text('Refresh Team',
            style: TextStyle(
              fontSize: 20,
            )),
        subtitle: Text('Get the latest data for your team'),
        trailing: Icon(Icons.refresh),
        onTap: () {
          setState(() {
            _isLoading = true;
          });

          loadTeamFromCloud().then((t) {
            globals.myTeam = t;
            setState(() {
              _isLoading = false;
            });
          });
        },
      ),
    ));

    allMembers.add(Container(
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
        title: Text('Leave Team',
            style: TextStyle(
              fontSize: 20,
            )),
        subtitle: Text('Stop sharing your HabitCoins wit the team'),
        trailing: Icon(Icons.directions_run),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("Leave Team?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      leaveTeam(globals.TeamID).then((_) {
                        Navigator.pop(context);
                        setState(() {
                          globals.TeamID = '';
                        });
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Are you sure you want to leave this team?')
                  ],
                ),
              );
            },
          );
        },
      ),
    ));

    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Center(
            child: Text(_isLoading ? 'Team' :
              globals.myTeam.Name,
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
            child: Column(
              children: !_isLoading
                  ? allMembers
                  : <Widget>[
                      LinearProgressIndicator(),
                    ],
            )),
      ],
    );
  }

  Widget buildJoinTeam() {
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Text(
              'To join a team, enter the Team ID you have been given.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: TextField(
            textCapitalization: TextCapitalization.characters,
            controller: txtJoinTeamID,
            decoration: InputDecoration(hintText: 'Enter Team ID'),
            style: TextStyle(
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: _isLoading
              ? LinearProgressIndicator()
              : RaisedButton(
                  onPressed: () {
                    joinTeam();
                  },
                  child: Text(
                    'Join Team',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Text(
            _error,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ],
    );
  }

  void joinTeam() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String teamID = txtJoinTeamID.text.trim();
    setState(() {
      _error = '';
      _isLoading = true;
    });

    if (teamID == '') {
      _error = 'You must enter a Team ID';
    } else {
      if (await doesTeamExist(teamID)) {
        await addCurrentUserToTeam(teamID);
        globals.TeamID = teamID;
        await loadTeamFromCloud().then((t) {
          globals.myTeam = t;
        });
      } else {
        _error = 'The Team ID you entered is invalid';
      }
    }

    Future.delayed(Duration(seconds: 1)).then((n) {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
