import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habit_coins/globals.dart' as globals;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  //print(directory.path);
  return directory.path;
}

Future<File> saveSchedule(Schedule s) async {
  final path = await _localPath;
  File file = File('$path/schedule.json');

  return file.writeAsString(json.encode(s.toJson()));
}

Future<File> saveName(String name) async {
  final path = await _localPath;
  File file = File('$path/name.json');

  return file.writeAsString(name);
}


Future<File> saveOnboardingComplete() async {
  final path = await _localPath;
  File file = File('$path/onboard.json');

  return file.writeAsString(true.toString());
}

Future<bool> loadOnboardStatus() async {
  // try {
  final path = await _localPath;

  File file = File('$path/onboard.json');
  if (file.existsSync()) {
    String contents = await file.readAsString();
//print(contents);
  
    return contents == 'true';
  } else {
    
    return false;
  }

}


Future<String> loadName() async {
  // try {
  final path = await _localPath;

  File file = File('$path/name.json');
  if (file.existsSync()) {
    String contents = await file.readAsString();
//print(contents);
  
    return contents;
  } else {
    
    return '';
  }

}

Future<File> saveDays(DayList d) async {
  final path = await _localPath;
  File file = File('$path/days.json');

  return file.writeAsString(json.encode(d));
}


Future<DayList> loadDays() async {
  // try {
  final path = await _localPath;

  File file = File('$path/days.json');
  if (file.existsSync()) {
    String contents = await file.readAsString();
//print(contents);
    globals.DaysLoaded = true;
    return DayList.fromJson(json.decode(contents));
  } else {
    globals.DaysLoaded = true;
    return new DayList();
  }

}

Future<Schedule> loadSchedule() async {
  // try {
  final path = await _localPath;

  File file = File('$path/schedule.json');
  if (file.existsSync()) {
    String contents = await file.readAsString();
//print(contents);
    globals.ScheduleLoaded = true;
    return Schedule.fromJson(json.decode(contents));
  } else {
    globals.ScheduleLoaded = true;
    return new Schedule();
  }

}
