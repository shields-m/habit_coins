import 'package:flutter/material.dart';

class Coin {
  String Name;

  IconData Icon;

  Coin(String name, IconData icon) {
    Icon = icon;
    Name = name;
  }

  Coin.fromDynamic(dynamic data)
  {
    Name=data['name'];
    Icon = IconData(data['icon']);

  }

  Coin.fromJson(Map<String, dynamic> json)
      : Name = json['name'],
        Icon = IconData(json['icon']);

  Map<String, dynamic> toJson() =>
      {
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
}