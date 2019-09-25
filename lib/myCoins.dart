import 'package:flutter/material.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';


GlobalKey<_CoinRowState> _coinRowStateKey = GlobalKey();
class MyCoins extends StatefulWidget {
  @override
  
 
  
  MyCoins(){

    item = new ScheduleItem();
    item.FirstDate = DateTime.now().add(Duration(days: -2));
    item.HabitCoin = new Coin('Run', Icons.directions_run);
    item.DaysOfWeek = ['Monday','Wednesday','Saturday'];

    schedule.AddItem(item);


    item = new ScheduleItem();
    item.FirstDate = DateTime.now().add(Duration(days: -2));
    item.HabitCoin = new Coin('Eat', Icons.fastfood);
    item.DaysOfWeek = ['Tuesday','Sunday',];
    schedule.AddItem(item);

    item = new ScheduleItem();
    item.FirstDate = DateTime.now().add(Duration(days: -2));
    item.HabitCoin = new Coin('Meet Frields', Icons.people);
    item.DaysOfWeek = ['Wednesday','Sunday',];



    schedule.AddItem(item);
  }
  
  
/*  List<Coin> _coins = [
    new Coin('Run', Icons.directions_run),
    new Coin('Eat', Icons.fastfood),
    new Coin('Wake Up Early', Icons.alarm),
    new Coin('Meet Friends', Icons.people),
    new Coin('Be Happy', Icons.tag_faces),
    new Coin('Expand My Horizons', Icons.zoom_out_map),
  ];*/

  Schedule schedule = new Schedule();
  ScheduleItem item = new ScheduleItem();




  Jar jar = new Jar();
  DateTime selectedDate = DateTime.now();

  _MyCoinsState createState() => _MyCoinsState();



}

class _MyCoinsState extends State<MyCoins> {
  @override
  Widget build(BuildContext context) {
   // fileWriter w = new fileWriter();
    //w.saveFile(this.widget._coins);


    

    return Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  setDate(this.widget.selectedDate.add(new Duration(days: -1)));
                },
                child: new Icon(
                  Icons.keyboard_arrow_left,
                  size: 32,
                ),
              ),
              new GestureDetector(
                onTap: () {
                  _selectDate();
                },
                child: new Text(
                  new DateFormat("E dd LLL yyyy")
                      .format(this.widget.selectedDate),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setDate(this.widget.selectedDate.add(new Duration(days: 1)));
                },
                child: new Icon(
                  Icons.keyboard_arrow_right,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        CoinRow( _coinRowStateKey,this.widget.schedule.getCoinsForDay(this.widget.selectedDate),),
        new Expanded(child: new JarWidget(this.widget.jar)),
      ],
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    if (picked != null) setState(() => setDate(picked));
  }

  void setDate(DateTime dateTime) {
    setState(() {
      this.widget.selectedDate = dateTime;

     /* this.widget._coins = [
        new Coin('Run', Icons.directions_run),
        new Coin('Eat', Icons.fastfood),
        new Coin('Wake Up Early', Icons.alarm),
        new Coin('Meet Friends', Icons.people),
        new Coin('Be Happy', Icons.tag_faces),
        new Coin('Expand My Horizons', Icons.zoom_out_map),
      ];*/

      this.widget.jar = new Jar();
    });
  }
}



class JarWidget extends StatefulWidget {
  Jar _jar;

  JarWidget(Jar jar) {
    _jar = jar;
  }

  @override
  _JarWidgetState createState() => _JarWidgetState();
}

class _JarWidgetState extends State<JarWidget> {
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAccept: (data) {
        return true;
      },
      onAccept: (Coin data) {
        if (!this.widget._jar.coins.contains(data)) {
          setState(() {
            this.widget._jar.coins.add(data);
          });
        }
      },
      builder: (context, Coin, List) {
        return new Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          color: Colors.red.withOpacity(.5),
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceAround,
              verticalDirection: VerticalDirection.up,
              children: this
                  .widget
                  ._jar
                  .coins
                  .map(
                    (coin) => new GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Remove Coin?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      print('Removing ' + coin.Name);
                                      setState(() {
                                        _coinRowStateKey.currentState.addCoin(coin);
                                        this.widget._jar.coins.remove(coin);


                                      });

                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                                content: Text(
                                    "Do you want to remove this coin from the jar?"),
                              );
                            },
                          );
                        },
                        child: new Container(
                          margin: EdgeInsets.all(3),
                          width: 75.0,
                          height: 75.0,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0.0, 0),
                              )
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              coin.Icon,
                              size: 33,
                            ),
                          ),
                        )),
                  )
                  .toList()),
        );
      },
    );
  }
}

class CoinRow extends StatefulWidget {
  @override
  _CoinRowState createState() => _CoinRowState();

  final List<Coin> coins;


  const CoinRow( Key key, this.coins) : super(key: key);

}

class _CoinRowState extends State<CoinRow> {

  void addCoin(Coin coin)
  {
setState(() {
  this.widget.coins.insert(0, coin);

});


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: this
            .widget
            .coins
            .map((coin) => LongPressDraggable(
                  onDragCompleted: () {
                    setState(() {
                      this.widget.coins.remove(coin);
                    });
                  },
                  data: coin,

                  // axis: Axis.vertical,
                  child: Container(
                    margin: EdgeInsets.all(6),
                    width: 110.0,
                    height: 110.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        coin.Icon,
                        size: 44,
                      ),
                    ),
                  ),
                  feedback: Container(
                    margin: EdgeInsets.all(6),
                    width: 120.0,
                    height: 120.0,
                    decoration: new BoxDecoration(
                      color: Colors.white.withOpacity(.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        coin.Icon,
                        size: 44,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    margin: EdgeInsets.all(6),
                    width: 110.0,
                    height: 110.0,
                    decoration: new BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.2),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0.0, 0),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        coin.Icon,
                        size: 44,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
