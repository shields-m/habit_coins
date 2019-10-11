import 'package:flutter/material.dart';
import 'package:habit_coins/icons.dart';

Future<IconData> selectIcon(BuildContext context) async {
  IconData selectedIcon;
IconSelector iconSelector = new IconSelector();
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("Select Icon"),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("Select"),
            onPressed: () {
              selectedIcon = IconData(allIcons[iconSelector.SelectedIcon], fontFamily: 'MaterialIcons');
              Navigator.pop(context);
            },
          )
        ],
        content: Container(
        // Specify some width
        width: MediaQuery.of(context).size.width * .8,
           child: iconSelector,
          
        ),
      );
    },
  );

  return selectedIcon;
}

class IconSelector extends StatefulWidget {
  @override
  _IconSelectorState createState() => _IconSelectorState();
int SelectedIcon = -1;

  IconSelector(){}
}

class _IconSelectorState extends State<IconSelector> {
 

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      
      physics: ScrollPhysics(),
      crossAxisCount: 4,
      children: List.generate(allIcons.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              this.widget.SelectedIcon = index;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: index == this.widget.SelectedIcon
                    ? Color.fromARGB(128, 53, 83, 165)
                    : Colors.white,
                width: 3,
              ),
              //borderRadius: BorderRadius.circular(16.0),
            ),
            child: Icon(
              IconData(allIcons[index], fontFamily: 'MaterialIcons'),
            ),
          ),
        );
      }),
    );
  }
}
