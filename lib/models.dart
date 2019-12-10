import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:habit_coins/schedule.dart' as schedule;
import 'package:habit_coins/schedule.dart';

import 'package:intl/intl.dart';

import 'localData.dart';

class Coin {
  String Name;
  String CloudID;
  IconData Icon;

  Coin(String name, IconData icon) {
    Icon = icon;
    Name = name;
    CloudID = '';
  }

  Coin.fromDynamic(dynamic data) {
    Name = data['name'];
    Icon = IconData(data['icon']);
  }

  factory Coin.fromJson(Map<String, dynamic> json) {
    Coin c = new Coin(
        json['name'],
        IconData(int.parse(json['icon'].toString()),
            fontFamily: 'MaterialIcons'));
    c.CloudID = json['cloudId'].toString();
    //print(c.Icon.codePoint);

    return c;
  }

  Map<String, dynamic> toJson() => {
        'name': Name,
        'icon': Icon.codePoint,
        'cloudId': CloudID,
      };

  @override
  String toString() => 'Name: ' + Name + ' Icon: ' + Icon.toString();
}

class Jar {
  String name;

  int coinsInJar;

  Day day;

  List<Coin> coins;

  Jar() {
    coins = new List<Coin>();
    day = new Day();
  }

  Jar.withCoins(List<Coin> coinlist) {
    coins = coinlist;
  }

  Jar.fromDay(Day d) {
    day = d;
    coins = d.coinsInJar;
  }
}

class Month {
  List<String> DaysCompleted;
  String MonthName;
  DateTime lastGotFromCloud;

  Month(String name) {
    MonthName = name;
    DaysCompleted = new List();
    lastGotFromCloud = new DateTime(9999);
  }

  Month.withDays(String month, List<String> days) {
    MonthName = month;
    DaysCompleted = days;
    lastGotFromCloud = new DateTime(9999);
  }

  Map<String, dynamic> toFireStoreMap() {
    Map<String, dynamic> today = {
      'month': MonthName,
      'daysCompleted': DaysCompleted,
    };
    return today;
  }

  Map<String, dynamic> toJson() => {
        'month': MonthName,
        'daysCompleted': DaysCompleted,
        'lastGotFromCloud': lastGotFromCloud.millisecondsSinceEpoch
      };

  factory Month.fromJson(Map<String, dynamic> j) {
    //print(j);
    List d = j['daysCompleted'] as List<dynamic>;
//print(d.toString());
    List<String> days = d.map((day) => day.toString()).toList();
    Month s = new Month.withDays(j['month'].toString(), days);
    try {
      s.lastGotFromCloud =
          DateTime.fromMillisecondsSinceEpoch(int.parse(j['lastGotFromCloud']));
    } catch (e) {
      s.lastGotFromCloud = new DateTime(9999);
    }
    return s;
  }
}

class MonthsList {
  Map<String, Month> Months;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> monthsmap = new Map();

    List<Month> months = new List();

    Months.forEach((x, x2) {
      months.add(x2);
    });

    monthsmap['months'] = months;

    return monthsmap;
  }

  Future<bool> saveLocally() async {
    await saveMonths(this);

    return true;
  }

  MonthsList() {
    Months = new Map();
  }

  factory MonthsList.fromJson(Map<String, dynamic> json) {
    //print(json);

    var days = json['months'] as List<dynamic>;

    //print(items);
    MonthsList d = new MonthsList();

    days.forEach((item) {
      d.Months[item['month']] = (Month.fromJson(item));
    });
    return d;
  }
}

class Day {
  List<Coin> pendingCoins;
  List<Coin> coinsInJar;

  DateTime lastGotFromCloud;

  Day() {
    pendingCoins = new List();
    coinsInJar = new List();
    lastGotFromCloud = new DateTime(9999);
  }

  Map<String, dynamic> toFireStoreMap(String todayKey) {
    Map<String, dynamic> today = {
      'date': todayKey,
      'coinsInJar': coinsInJar
          .map((coin) => {
                'name': coin.Name,
                'icon': coin.Icon.codePoint,
                'cloudId': coin.CloudID
              })
          .toList(),
      'pendingCoins': pendingCoins
          .map((coin) => {
                'name': coin.Name,
                'icon': coin.Icon.codePoint,
                'cloudId': coin.CloudID
              })
          .toList(),
    };

    return today;
  }

  bool complete() => totalCoinCount() > 0 && pendingCoins.length == 0;

  Map<String, dynamic> toJson() => {
        'pendingCoins': pendingCoins.map((item) => item.toJson()).toList(),
        'coinsInJar': coinsInJar.map((item) => item.toJson()).toList(),
        'lastGotFromCloud': lastGotFromCloud.millisecondsSinceEpoch
      };

  factory Day.fromJson(Map<String, dynamic> json) {
    //print(json);
    var pend = json['pendingCoins'] as List<dynamic>;
    //print( pend);
    var jar = json['coinsInJar'] as List<dynamic>;
    //print(jar);
    //print(items);
    Day d = new Day();
    d.pendingCoins = pend
        .map((item) => new Coin(
            item['name'],
            IconData(int.parse(item['icon'].toString()),
                fontFamily: 'MaterialIcons')))
        .toList();
    d.coinsInJar = jar
        .map((item) => new Coin(
            item['name'],
            IconData(int.parse(item['icon'].toString()),
                fontFamily: 'MaterialIcons')))
        .toList();

    try {
      d.lastGotFromCloud = DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['lastGotFromCloud']));
    } catch (e) {
      d.lastGotFromCloud = new DateTime(9999);
    }
    //d.pendingCoins = pend.map((item) => new Coin.fromJson(item)).toList();
    //d.coinsInJar = jar.map((item) => new Coin.fromJson(item)).toList();
    return d;
  }

  int totalCoinCount() => pendingCoins.length + coinsInJar.length;
}

class DayList {
  Map<String, Day> days;

  DayList() {
    days = new HashMap();
  }

  Future<bool> saveLocally() async {
    trimList();
    await saveDays(this);

    return true;
  }

  void trimList() {
    int daycount = 30;

    int firstday =
        int.parse(getDayKey(DateTime.now().add(Duration(days: -daycount))));

    days.removeWhere((key, value) => int.parse(key) < firstday);
  }

  String getDayKey(DateTime dt) {
    String d = NumberFormat('0000').format(dt.year) +
        NumberFormat('00').format(dt.month) +
        NumberFormat('00').format(dt.day);

    return d;
  }

  Map<String, dynamic> toJson() {
    List<DayJsonObject> d = new List();
    days.forEach((key, value) => {d.add(new DayJsonObject(key, value))});
    Map<String, dynamic> dd = new Map<String, dynamic>();
    dd['days'] = d.map((item) => item.toJson()).toList();

    return dd;
  }

  factory DayList.fromJson(Map<String, dynamic> json) {
    //print(json);
    var days = json['days'] as List<dynamic>;

    //print(items);
    DayList d = new DayList();

    days.forEach((item) {
      d.days[item['date'].toString()] = Day.fromJson(item['day']);
    });
    return d;
  }
}

class DayJsonObject {
  String date;
  Day day;

  DayJsonObject(String _date, Day _day) {
    day = _day;
    date = _date;
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'day': day.toJson(),
      };

  factory DayJsonObject.fromJson(Map<String, dynamic> json) {
    return new DayJsonObject(
        json['date'].toString(), Day.fromJson(json['day']));
  }
}

class TeamMember {
  String Name;
  String Role;
  String ID;

  DayList Days;

  MonthsList Months;

  schedule.Schedule Schedule;

  TeamMember() {
    Days = new DayList();
    Months = new MonthsList();
    Schedule = new schedule.Schedule();
  }
}

class UserDetails {
  String ID;
  String TeamID;
  bool isUnless;
  bool shareWithUnless;

  UserDetails() {
    ID = '';
    TeamID = '';
    isUnless = false;
    shareWithUnless = false;
  }
}

class Person
{
  String id;
  String name;
  Schedule schedule;

  MonthsList months;

  DayList days;

  DateTime lastGotFromCloud;

  Person()
  {
    lastGotFromCloud = DateTime(1999);
  }

}

class Team {
  DateTime LastGotFromCloud;
  String Name;
  bool shareWithUnless;
  Map<String, TeamMember> Members;

  Team() {
    Members = new Map();
    LastGotFromCloud = DateTime.now().add(Duration(minutes: -150));
    shareWithUnless = false;
  }
}
