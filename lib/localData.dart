import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habit_coins/globals.dart' as globals;


import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  //print(directory.path);
  return directory.path;
}

Future<File> saveSchedule(Schedule s) async {
  final path = await _localPath;
  File file = File('$path/schedule.json');
  // if (globals.UseCloudSync && globals.CurrentUser != '') {
  //   bool connected = await DataConnectionChecker().hasConnection;
  //   if (connected) {
  //     //Save Schedule To Cloud
  //   }
  // }

  return file.writeAsString(json.encode(s.toJson()));
}

Future<bool> loadScheduleFromCloud() async {
  bool loaded = false;
  Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .get()
      .then((doc) {
    if (doc.exists) {
      print('exists');
      Firestore.instance
          .collection('users')
          .document(globals.CurrentUser)
          .collection('schedule')
          .getDocuments()
          .then((s) {
        print('got schedule');
        print(s.documents.isEmpty);
        List<ScheduleItem> sched = new List();
        ScheduleItem item;
        s.documents.forEach((d) {
          print(d.documentID);
          item = new ScheduleItem();
          item.HabitCoin = new Coin(
              d.data['coinName'],
              IconData(int.parse(d.data['coinIcon'].toString()),
                  fontFamily: 'MaterialIcons'));
          item.HabitCoin.CloudID = d.documentID;
          List da = d.data['daysOfWeek'] as List<dynamic>;
          List<String> days = da.map((day) => day.toString()).toList();

          item.FirstDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(d.data['firstDate'].toString()));
          item.LastDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(d.data['lastDate'].toString()));

          item.DaysOfWeek = days;
          sched.add(item);
        });
        globals.mainSchedule = new Schedule.withItems(sched);
        globals.mainSchedule.saveLocally().then((_) {
          loaded = true;
          DateTime selectedDate = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day);
          if (!globals.days.days.containsKey(globals.getDayKey(selectedDate))) {
            Day today = new Day();

            today.coinsInJar = new List<Coin>();

            today.pendingCoins =
                globals.mainSchedule.getCoinsForDay(selectedDate);
            globals.days.days[globals.getDayKey(selectedDate)] = today;
          }
        });
      });
    } else {
      loaded = false;
    }
  });

  return loaded;
}

Future<bool> saveScheduleToCloud() async {
  await deleteFromCloud();
  print('deleted');
  await ensureUserExists();

  print('user exists');
  bool saved = true;

  var db = Firestore.instance;
  var batch = db.batch();
  globals.mainSchedule.Items.forEach((f) {
    print(f.HabitCoin.Name);

    DocumentReference ref;

    if (f.HabitCoin.CloudID == null) {
      ref = db
          .collection('users')
          .document(globals.CurrentUser)
          .collection('schedule')
          .document();
      batch.setData(ref, {
        'firstDate': f.FirstDate.millisecondsSinceEpoch,
        'lastDate': f.LastDate.millisecondsSinceEpoch,
        'daysOfWeek': f.DaysOfWeek,
        'coinName': f.HabitCoin.Name,
        'coinIcon': f.HabitCoin.Icon.codePoint,
      });
      f.HabitCoin.CloudID = ref.documentID;
      //print(f.HabitCoin.CloudID);
      //print(ref.documentID);
    } else {
      batch.setData(
          db
              .collection('users')
              .document(globals.CurrentUser)
              .collection('schedule')
              .document(f.HabitCoin.CloudID),
          {
            'firstDate': f.FirstDate.millisecondsSinceEpoch,
            'lastDate': f.LastDate.millisecondsSinceEpoch,
            'daysOfWeek': f.DaysOfWeek,
            'coinName': f.HabitCoin.Name,
            'coinIcon': f.HabitCoin.Icon.codePoint,
          });
    }

    //print(f.HabitCoin.CloudID);
  });
  await batch.commit();
  return saved;
}

Future<bool> ensureUserExists() async {
  Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .get()
      .then((doc) {
    if (doc.exists) {
    } else {
      loadName().then((name) {
        Firestore.instance
            .collection('users')
            .document(globals.CurrentUser)
            .setData({'name': name});
      });
    }
  });
  return true;
}

Future<bool> userExists() async {
  bool exists;
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .get()
      .then((doc) {
    exists = doc.exists;
  });
  return exists;
}


Future<bool> deleteFromCloud() async {
  var batch = Firestore.instance.batch();

  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('schedule')
      .getDocuments()
      .then((s) async {
    s.documents.forEach((d) {
      batch.delete(d.reference);
    });
    await batch.commit();
  });

  // Firestore.instance
  //           .collection('users')
  //           .document(globals.CurrentUser)
  //           .collection('schedule')
  //           .document(d.documentID)
  //           .delete();

  return true;
}

Future<bool> deleteCoinFromCloud(String cloudId) async
{
  bool done = true;
  await Firestore.instance.collection('users').document(globals.CurrentUser).collection('schedule').document(cloudId).delete().whenComplete((){

    done = true;
  });
return done;
}


Future<String> addCoinToCloud(ScheduleItem item) async
{
  String done = '';
  await Firestore.instance.collection('users').document(globals.CurrentUser).collection('schedule').add({
            'firstDate': item.FirstDate.millisecondsSinceEpoch,
            'lastDate': item.LastDate.millisecondsSinceEpoch,
            'daysOfWeek': item.DaysOfWeek,
            'coinName': item.HabitCoin.Name,
            'coinIcon': item.HabitCoin.Icon.codePoint,
          }).then((ref){

    done = ref.documentID;
  });
return done;
}

Future<bool> updateCoinInCloud(ScheduleItem item) async
{
  bool done = true;
  await Firestore.instance.collection('users').document(globals.CurrentUser).collection('schedule').document(item.HabitCoin.CloudID).setData({
            'firstDate': item.FirstDate.millisecondsSinceEpoch,
            'lastDate': item.LastDate.millisecondsSinceEpoch,
            'daysOfWeek': item.DaysOfWeek,
            'coinName': item.HabitCoin.Name,
            'coinIcon': item.HabitCoin.Icon.codePoint,
          }).then((ref){

    done = true;
  });
return done;
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
