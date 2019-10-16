import 'dart:convert';

import 'package:habit_coins/localData.dart';
import 'package:habit_coins/models.dart';

import 'models.dart';

import 'package:intl/intl.dart';

import 'package:habit_coins/globals.dart' as globals;

class ScheduleItem {
  DateTime FirstDate;

  DateTime LastDate;

  List<String> DaysOfWeek;

  Coin HabitCoin;

  bool Delete;

  ScheduleItem() {
    DaysOfWeek = new List();
    LastDate = DateTime.utc(9999);
    Delete = false;
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> j) {

List d = j['daysOfWeek'] as List<dynamic>;
//print(d.toString());
List<String> days = d.map((day)=> day.toString()).toList();

    ScheduleItem s = new ScheduleItem();
    s.FirstDate = DateTime.fromMillisecondsSinceEpoch(int.parse(j['firstDate'].toString()));
    s.LastDate = DateTime.fromMillisecondsSinceEpoch(int.parse(j['lastDate'].toString()));
    s.HabitCoin = new Coin.fromJson(j['coin']);
    s.DaysOfWeek = days;

    return s;
  }

  Map<String, dynamic> toJson() => {
        'firstDate': FirstDate.millisecondsSinceEpoch,
        'lastDate': LastDate.millisecondsSinceEpoch,
        'daysOfWeek': DaysOfWeek,
        'coin': HabitCoin.toJson()
      };
}

class Schedule {
  List<ScheduleItem> Items;

  Schedule() {
    Items = new List();
  }
  factory Schedule.fromJson(Map<String, dynamic> json) {
    //print(json);
    var items = json['items'] as List<dynamic>;
    //print(items);
    Schedule s = new Schedule();

    s.Items = items.map((item) => new ScheduleItem.fromJson(item)).toList();

    return s;
  }

   Schedule.withItems(List<ScheduleItem> items)
  {
Items = items;

  }
  

  String prt()
  {
    String s = '';
    Items.forEach((f) => s += f.HabitCoin.Name + ', ' + f.DaysOfWeek.toString());
return s;
  }

  Future<bool> saveLocally() async
  {
     await saveSchedule(this);

     return true;

  }

  Map<String, dynamic> toJson() => {
        'items': Items.map((item) => item.toJson()).toList(),
      };

  void AddItem(ScheduleItem item) {
    Items.add(item);
  }

  void RemoveItem(ScheduleItem item) {
    if (Items.contains(item)) {
      Items.remove(item);
    }
  }

  List<Coin> getCoinsForDay(DateTime dateTime) {
    List<Coin> coins = new List();
    String weekday = DateFormat("EEEE").format(dateTime);
    //print(weekday);
    Items.forEach((item) => {
          if (item.DaysOfWeek.contains(weekday) &&
              dateTime.isAfter(item.FirstDate.add(Duration(days: -1))) &&
              dateTime.isBefore(item.LastDate.add(Duration(days: 1))))
            {coins.add(item.HabitCoin)}
        });

    return coins;
  }
}
