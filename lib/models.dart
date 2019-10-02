import 'dart:collection';

import 'package:flutter/material.dart';

import 'localData.dart';

class Coin {
  String Name;

  IconData Icon;

  Coin(String name, IconData icon) {
    Icon = icon;
    Name = name;
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
    //print(c.Icon.codePoint);

    return c;
  }

  Map<String, dynamic> toJson() => {
        'name': Name,
        'icon': Icon.codePoint,
      };

  @override
  String toString() => 'Name: ' + Name + ' Icon: ' + Icon.toString();
}

class Jar {
  String name;

  int coinsInJar;

  List<Coin> coins;

  Jar() {
    coins = new List<Coin>();
  }

  Jar.withCoins(List<Coin> coinlist)
  {
    coins = coinlist;
  }
}

class Day {
  List<Coin> pendingCoins;
  List<Coin> coinsInJar;

  Day() {
    pendingCoins = new List();
    coinsInJar = new List();
  }

  Map<String, dynamic> toJson() => {
        'pendingCoins': pendingCoins.map((item) => item.toJson()).toList(),
        'coinsInJar': coinsInJar.map((item) => item.toJson()).toList(),
      };

  factory Day.fromJson(Map<String, dynamic> json) {
    //print(json);
    var pend = json['pendingCoins'] as List<dynamic>;
    var jar = json['coinsInJar'] as List<dynamic>;

    //print(items);
    Day d = new Day();

    d.pendingCoins = pend.map((item) => new Coin.fromJson(item)).toList();
    d.coinsInJar = jar.map((item) => new Coin.fromJson(item)).toList();
    return d;
  }

  int totalCoinCount() => pendingCoins.length + coinsInJar.length;
}

class DayList {
  Map<String, Day> days;

  DayList() {
    days = new HashMap();
  }

  Future<bool> saveLocally() async
  {
     await saveDays(this);

     return true;

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

    days.forEach((item){
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
