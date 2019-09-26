import 'dart:io';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:habit_coins/icons.dart';

class AddCoin extends StatefulWidget {
  AddCoin() {
    selectedIcon = Icons.schedule;
    Days = new List();

    List<PickerItem> p = new List();
    allIcons.forEach((icon) => {p.add(_buildPickerDataItem(icon))});

    icons = PickerDataAdapter(data: p);
  }

  PickerItem _buildPickerDataItem(int icon) {
    return new PickerItem(
        text: Icon(IconData(icon, fontFamily: 'MaterialIcons')),
        value: IconData(icon, fontFamily: 'MaterialIcons'));
  }

  PickerDataAdapter icons;
  IconData selectedIcon;

  List<String> Days;

  @override
  _AddCoinState createState() => _AddCoinState();
}

class _AddCoinState extends State<AddCoin> {
  final txtNewCoinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScheduleItem sitem;
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
                      'Add HabitCoin',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
    
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Coin Name:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      TextField(
                        controller: txtNewCoinController,
                      )
                    ],
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
                    title: Text(
                      'Select Icon',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showPickerIcons(context, this.widget.icons);
                    },
                    trailing: Icon(
                      this.widget.selectedIcon,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Days Of Week:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text('Monday'),
                        value: this.widget.Days.contains('Monday'),
                        onChanged: (bool value) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            if (value) {
                              this.widget.Days.add('Monday');
                            } else {
                              this.widget.Days.remove('Monday');
                            }
    //this.widget.Days.add('Monday');
                            //print(this.widget.Days);
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Tuesday'),
                        value: this.widget.Days.contains('Tuesday'),
                        onChanged: (bool value) {
                          setState(() {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            if (value) {
                              this.widget.Days.add('Tuesday');
                            } else {
                              this.widget.Days.remove('Tuesday');
                            }
    //this.widget.Days.add('Monday');
                            //print(this.widget.Days);
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Wednesday'),
                        value: this.widget.Days.contains('Wednesday'),
                        onChanged: (bool value) {
                          setState(() {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            if (value) {
                              this.widget.Days.add('Wednesday');
                            } else {
                              this.widget.Days.remove('Wednesday');
                            }
    //this.widget.Days.add('Monday');
                            //print(this.widget.Days);
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Thursday'),
                        value: this.widget.Days.contains('Thursday'),
                        onChanged: (bool value) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            if (value) {
                              this.widget.Days.add('Thursday');
                            } else {
                              this.widget.Days.remove('Thursday');
                            }
    //this.widget.Days.add('Monday');
                           // print(this.widget.Days);
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Friday'),
                        value: this.widget.Days.contains('Friday'),
                        onChanged: (bool value) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            if (value) {
                              this.widget.Days.add('Friday');
                            } else {
                              this.widget.Days.remove('Friday');
                            }
    //this.widget.Days.add('Monday');
                           // print(this.widget.Days);
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Saturday'),
                        value: this.widget.Days.contains('Saturday'),
                        onChanged: (bool value) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            if (value) {
                              this.widget.Days.add('Saturday');
                            } else {
                              this.widget.Days.remove('Saturday');
                            }
    //this.widget.Days.add('Monday');
                            //print(this.widget.Days);
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Sunday'),
                        value: this.widget.Days.contains('Sunday'),
                        onChanged: (bool value) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          setState(() {
                            if (value) {
                              this.widget.Days.add('Sunday');
                            } else {
                              this.widget.Days.remove('Sunday');
                            }
    //this.widget.Days.add('Monday');
                            //print(this.widget.Days);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromARGB(128, 53, 83, 165),
                        width: 1,
                      ),
                    ),
                    //borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        onPressed: () => {Navigator.pop(context)},
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 14.0,
                              textBaseline: TextBaseline.alphabetic),
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        onPressed: () => {
     sitem  = new ScheduleItem(),
     sitem.HabitCoin = new Coin(txtNewCoinController.text,this.widget.selectedIcon),
     sitem.DaysOfWeek = this.widget.Days,
     sitem.FirstDate = DateTime.now(),
     sitem.LastDate = DateTime(9999),
     Navigator.pop(context, sitem)


                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                          fontSize: 14.0,
                          textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                ],
              ),
            ),
            //Padding(padding: EdgeInsets.symmetric(vertical: 10),),
          ],
        ),
      ),
    );
  }

  showPickerIcons(BuildContext context, PickerDataAdapter data) {
    //sleep(Duration(milliseconds: 100));
    new Picker(
        hideHeader: true,
        looping: true,
        itemExtent: 40,
        height: 100,
        adapter: data,
        title: new Text("Select Icon"),
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());
          setState(() {
            this.widget.selectedIcon = picker.getSelectedValues()[0];
          });
        }).showDialog(context);
  }
}
