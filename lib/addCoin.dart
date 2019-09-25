import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddCoin extends StatefulWidget {
  AddCoin() {
    selectedIcon = Icons.schedule;
    Days = new List();
  }

  IconData selectedIcon;

  List<String> Days;

  @override
  _AddCoinState createState() => _AddCoinState();
}

class _AddCoinState extends State<AddCoin> {
  final txtNewCoinController = TextEditingController();

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
                  showPickerIcons(context);
                },
                trailing: Icon(this.widget.selectedIcon),
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
                      setState(() {
                        if (value) {
                          this.widget.Days.add('Monday');
                        } else {
                          this.widget.Days.remove('Monday');
                        }
//this.widget.Days.add('Monday');
                        print(this.widget.Days);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Tuesday'),
                    value: this.widget.Days.contains('Tuesday'),
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          this.widget.Days.add('Tuesday');
                        } else {
                          this.widget.Days.remove('Tuesday');
                        }
//this.widget.Days.add('Monday');
                        print(this.widget.Days);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Wednesday'),
                    value: this.widget.Days.contains('Wednesday'),
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          this.widget.Days.add('Wednesday');
                        } else {
                          this.widget.Days.remove('Wednesday');
                        }
//this.widget.Days.add('Monday');
                        print(this.widget.Days);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Thursday'),
                    value: this.widget.Days.contains('Thursday'),
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          this.widget.Days.add('Thursday');
                        } else {
                          this.widget.Days.remove('Thursday');
                        }
//this.widget.Days.add('Monday');
                        print(this.widget.Days);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Friday'),
                    value: this.widget.Days.contains('Friday'),
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          this.widget.Days.add('Friday');
                        } else {
                          this.widget.Days.remove('Friday');
                        }
//this.widget.Days.add('Monday');
                        print(this.widget.Days);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Saturday'),
                    value: this.widget.Days.contains('Saturday'),
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          this.widget.Days.add('Saturday');
                        } else {
                          this.widget.Days.remove('Saturday');
                        }
//this.widget.Days.add('Monday');
                        print(this.widget.Days);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Sunday'),
                    value: this.widget.Days.contains('Sunday'),
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          this.widget.Days.add('Sunday');
                        } else {
                          this.widget.Days.remove('Sunday');
                        }
//this.widget.Days.add('Monday');
                        print(this.widget.Days);
                      });
                    },
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

  showPickerIcons(BuildContext context) {
    new Picker(
        hideHeader: true,
        looping: true,
        itemExtent: 60,
        height: 250,
        adapter: PickerDataAdapter(data: [
          new PickerItem(
            text: Icon(Icons.add, size: 60),
            value: Icons.add,
          ),
          new PickerItem(
            text: Icon(Icons.title, size: 60),
            value: Icons.title,
          ),
          new PickerItem(
            text: Icon(Icons.face, size: 60),
            value: Icons.face,
          ),
          new PickerItem(
            text: Icon(Icons.linear_scale, size: 60),
            value: Icons.linear_scale,
          ),
          new PickerItem(text: Icon(Icons.close, size: 60), value: Icons.close),
        ]),
        title: new Text("Select Icon"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            this.widget.selectedIcon = picker.getSelectedValues()[0];
          });
        }).showDialog(context);
  }
}
