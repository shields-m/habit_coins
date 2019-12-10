import 'dart:convert'; //to convert json to maps and vice versa
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habit_coins/models.dart';
import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';
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
      //print('exists');
      Firestore.instance
          .collection('users')
          .document(globals.CurrentUser)
          .collection('schedule')
          .getDocuments()
          .then((s) {
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

Future<Schedule> loadScheduleFromCloudForUser(String id) async {
  Schedule schedule = new Schedule();

  await Firestore.instance
      .collection('users')
      .document(id)
      .collection('schedule')
      .getDocuments()
      .then((s) {
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
    print(sched);
    schedule = new Schedule.withItems(sched);
    
  });

  return schedule;
}

Future<bool> saveTodayToCloud() async {
  String todayKey = globals.getDayKey(DateTime.now());
  Map<String, dynamic> today =
      globals.days.days[todayKey].toFireStoreMap(todayKey);
  print(today);
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('days')
      .document(todayKey)
      .setData(today);
  return true;
}

Future<bool> saveAllDaysToCloud() async {
  await deleteDaysFromCloud();
  Map<String, dynamic> data = new Map();

  globals.days.days.forEach((key, day) => data[key] = day.toFireStoreMap(key));
  var batch = Firestore.instance.batch();
  data.forEach((z, day) {
    batch.setData(
        Firestore.instance
            .collection('users')
            .document(globals.CurrentUser)
            .collection('days')
            .document(z),
        day);
  });
  await batch.commit();

  return true;
}

Future<Day> getDayFromCloud(DateTime date) async {
  String dateKey = globals.getDayKey(date);
  print('Getting day from cloud: ' + dateKey);
  Day d;
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('days')
      .document(dateKey)
      .get()
      .then((doc) {
    if (doc.exists) {
      //print(doc.data);
      d = new Day.fromJson(doc.data);
    } else {
      d = new Day();
      d.coinsInJar = new List<Coin>();

      d.pendingCoins = globals.mainSchedule.getCoinsForDay(date);
    }
  });
  d.lastGotFromCloud = DateTime.now();
  return d;
}

Future<Day> getDayFromCloudForUser(DateTime date, String user) async {
  String dateKey = globals.getDayKey(date);
  print('Getting day from cloud: ' + dateKey + ' for ' + user);
  Day d;
  await Firestore.instance
      .collection('users')
      .document(user)
      .collection('days')
      .document(dateKey)
      .get()
      .then((doc) {
    if (doc.exists) {
      //print(doc.data);
      d = new Day.fromJson(doc.data);
    } else {
      d = new Day();
      d.coinsInJar = new List<Coin>();

      //d.pendingCoins = globals.people[user].schedule.getCoinsForDay(date);
      d.pendingCoins = new List();
    }
  });
  d.lastGotFromCloud = DateTime.now();
  return d;
}

Future<bool> saveCurrentMonthToCloud() async {
  String month = new DateFormat("LLL yyyy").format(DateTime.now());
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('months')
      .document(month)
      .setData(globals.monthsList.Months[month].toFireStoreMap());

  return true;
}

Future<bool> saveAlltMonthsToCloud() async {
  await deleteMonthsFromCloud();
  var batch = Firestore.instance.batch();
  globals.monthsList.Months.forEach((key, month) => batch.setData(
      Firestore.instance
          .collection('users')
          .document(globals.CurrentUser)
          .collection('months')
          .document(key),
      month.toFireStoreMap()));
  await batch.commit();
  return true;
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
    print('CloudID: ' + f.HabitCoin.CloudID.toString());
    if (f.HabitCoin.CloudID == '' || f.HabitCoin.CloudID == null) {
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
      .then((s) {
    s.documents.forEach((d) {
      batch.delete(d.reference);
    });
  });
  await batch.commit();
  // Firestore.instance
  //           .collection('users')
  //           .document(globals.CurrentUser)
  //           .collection('schedule')
  //           .document(d.documentID)
  //           .delete();

  return true;
}

Future<bool> deleteMonthsFromCloud() async {
  var batch = Firestore.instance.batch();

  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('months')
      .getDocuments()
      .then((s) {
    s.documents.forEach((d) {
      batch.delete(d.reference);
    });
  });
  await batch.commit();
  return true;
}

Future<bool> deleteDaysFromCloud() async {
  var batch = Firestore.instance.batch();

  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('days')
      .getDocuments()
      .then((s) {
    s.documents.forEach((d) {
      batch.delete(d.reference);
    });
  });
  await batch.commit();
  return true;
}

Future<bool> deleteCoinFromCloud(String cloudId) async {
  bool done = true;
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('schedule')
      .document(cloudId)
      .delete()
      .whenComplete(() {
    done = true;
  });
  return done;
}

Future<String> addCoinToCloud(ScheduleItem item) async {
  String done = '';
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('schedule')
      .add({
    'firstDate': item.FirstDate.millisecondsSinceEpoch,
    'lastDate': item.LastDate.millisecondsSinceEpoch,
    'daysOfWeek': item.DaysOfWeek,
    'coinName': item.HabitCoin.Name,
    'coinIcon': item.HabitCoin.Icon.codePoint,
  }).then((ref) {
    done = ref.documentID;
  });
  return done;
}

Future<bool> updateCoinInCloud(ScheduleItem item) async {
  bool done = true;
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('schedule')
      .document(item.HabitCoin.CloudID)
      .setData({
    'firstDate': item.FirstDate.millisecondsSinceEpoch,
    'lastDate': item.LastDate.millisecondsSinceEpoch,
    'daysOfWeek': item.DaysOfWeek,
    'coinName': item.HabitCoin.Name,
    'coinIcon': item.HabitCoin.Icon.codePoint,
  }).then((ref) {
    done = true;
  });
  return done;
}

Future<bool> createUserInCloud(String id, String name) async {
  await Firestore.instance.collection('users').document(id).setData({
    'name': name,
    'isUnless': false,
    'teamID': '',
    'shareWithUnless': false
  });
}

Future<File> saveName(String name) async {
  final path = await _localPath;
  File file = File('$path/name.json');
  if (globals.UseCloudSync) {
    await Firestore.instance
        .collection('users')
        .document(globals.CurrentUser)
        .updateData({'name': name});
  }
  return file.writeAsString(name);
}

Future<void> setShareWithUnlessForCurrentUser(bool value) async {
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .updateData({'shareWithUnless': value});
  return null;
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

Future<File> saveMonths(MonthsList d) async {
  final path = await _localPath;
  File file = File('$path/months.json');
  if (globals.UseCloudSync) {
    saveCurrentMonthToCloud();
  }
  return file.writeAsString(json.encode(d));
}

Future<MonthsList> loadMonths() async {
  // return new MonthsList();
  String month = new DateFormat("LLL yyyy").format(DateTime.now());
  // try {
  final path = await _localPath;

  File file = File('$path/months.json');
  if (file.existsSync()) {
    String contents = await file.readAsString();
//print(contents);
    globals.MonthsLoaded = true;

    MonthsList m = MonthsList.fromJson(json.decode(contents));
    if (globals.UseCloudSync) {
      m.Months[month] = await getMonthFromCloud(month);
    }

    return m;
  } else {
    globals.MonthsLoaded = true;
    MonthsList m = new MonthsList();
    if (globals.UseCloudSync) {
      m.Months[month] = await getMonthFromCloud(month);
    }
    return m;
  }
}

Future<Month> getMonthFromCloud(String month) async {
  Month m;
  print('loading month from cloud ' + month);
  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .collection('months')
      .document(month)
      .get()
      .then((doc) {
    if (doc.exists) {
      //print(doc.data);
      m = new Month.fromJson(doc.data);
      m.lastGotFromCloud = DateTime.now();
    } else {
      m = new Month(month);
      m.lastGotFromCloud = DateTime.now();
    }
  });
  return m;
}

Future<Month> getMonthFromCloudForUser(String month, String user) async {
  Month m;
  print('loading month from cloud ' + month + ' for ' + user);
  await Firestore.instance
      .collection('users')
      .document(user)
      .collection('months')
      .document(month)
      .get()
      .then((doc) {
    if (doc.exists) {
      //print(doc.data);
      m = new Month.fromJson(doc.data);
      m.lastGotFromCloud = DateTime.now();
    } else {
      m = new Month(month);
      m.lastGotFromCloud = DateTime.now();
    }
  });
  return m;
}

Future<File> saveDays(DayList d) async {
  final path = await _localPath;
  File file = File('$path/days.json');
  if (globals.UseCloudSync) {
    saveTodayToCloud();
    //saveAllDaysToCloud();
  }
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

Future<bool> doesTeamExist(String teamID) async {
  bool exists = false;
  var doc = await Firestore.instance.collection('teams').document(teamID).get();
  exists = doc.exists;
  return exists;
}

Future<Person> loadPerson(String id) async {
  Person p = new Person();
  p.id = id;
  p.lastGotFromCloud = DateTime.now();
  var db = Firestore.instance;

  var user = await db.collection('users').document(id).get();
  if (user.exists) {
    p.name = user.data['name'];
    p.schedule = await loadScheduleFromCloudForUser(id);
    print(p.schedule.Items);
    p.days = new DayList();
    p.days.days[globals.getDayKey(DateTime.now())] =
        await getDayFromCloudForUser(DateTime.now(), id);
    String month = new DateFormat("LLL yyyy").format(DateTime.now());
    p.months = new MonthsList();
    p.months.Months[month] = await getMonthFromCloudForUser(month, id);
  }

  return p;
}

Future<bool> doesTeamShareWithUnless(String teamID) async {
  bool share = false;
  var doc = await Firestore.instance.collection('teams').document(teamID).get();
  share = doc.data['shareWithUnless'].toString().toLowerCase() == 'true';
  return share;
}

Future<bool> addCurrentUserToTeam(String teamID, bool allowSharing) async {
  //TODO: Transaction for this
  await Firestore.instance
      .collection('teams')
      .document(teamID)
      .collection('members')
      .document(globals.CurrentUser)
      .setData({
    'dateJoined': DateTime.now(),
    'role': 'Team Member',
  });

  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .updateData({
    'teamID': teamID,
    'shareWithUnless': allowSharing,
  });

  return true;
}

Future<bool> leaveTeam(String teamID) async {
  await Firestore.instance
      .collection('teams')
      .document(teamID)
      .collection('members')
      .document(globals.CurrentUser)
      .delete();

  await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .updateData({
    'teamID': '',
  });

  return true;
}

Future<String> getTeamIDForCurrentUser() async {
  String id = '';
  var doc = await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .get();
  if (doc.exists) {
    id = doc.data['teamID'].toString();
  }

  return id;
}

Future<UserDetails> getUserDetailsForCurrentUser() async {
  print('User : ' + globals.CurrentUser);
  UserDetails d = new UserDetails();
  var doc = await Firestore.instance
      .collection('users')
      .document(globals.CurrentUser)
      .get();
  if (doc.exists) {
    print(doc.data);
    d.TeamID = doc.data['teamID'].toString();
    d.isUnless = doc.data['isUnless'].toString().toLowerCase() == 'true';
    d.shareWithUnless =
        doc.data['shareWithUnless'].toString().toLowerCase() == 'true';
  }
  print('Team : ' + d.TeamID);
  return d;
}

Future<Team> loadTeamFromCloud() async {
  print('loading team');
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String daykey = globals.getDayKey(today);
  String month = new DateFormat("LLL yyyy").format(today);
  Team t = new Team();
  t.LastGotFromCloud = DateTime.now();
  if (globals.userDetails.TeamID != null && globals.userDetails.TeamID != '') {
    var teamdata = (await Firestore.instance
            .collection('teams')
            .document(globals.userDetails.TeamID)
            .get())
        .data;
    t.Name = teamdata['teamName'];
    t.shareWithUnless =
        teamdata['shareWithUnless'].toString().toLowerCase() == 'true';

    var docs = await Firestore.instance
        .collection('teams')
        .document(globals.userDetails.TeamID)
        .collection('members')
        .getDocuments();

    for (var doc in docs.documents) {
      String userid = doc.documentID;
      TeamMember tm = new TeamMember();
      t.Members[userid] = tm;
      tm.ID = userid;
      tm.Role = doc.data['role'];
      var d =
          await Firestore.instance.collection('users').document(userid).get();
      tm.Name = d.data['name'];

      // var s = await Firestore.instance
      //     .collection('users')
      //     .document(userid)
      //     .collection('schedule')
      //     .getDocuments();

      // List<ScheduleItem> sched = new List();
      // ScheduleItem item;
      // for (var si in s.documents) {
      //   //print(d.documentID);
      //   item = new ScheduleItem();
      //   item.HabitCoin = new Coin(
      //       si.data['coinName'],
      //       IconData(int.parse(si.data['coinIcon'].toString()),
      //           fontFamily: 'MaterialIcons'));
      //   item.HabitCoin.CloudID = si.documentID;
      //   List da = si.data['daysOfWeek'] as List<dynamic>;
      //   List<String> days = da.map((day) => day.toString()).toList();

      //   item.FirstDate = DateTime.fromMillisecondsSinceEpoch(
      //       int.parse(si.data['firstDate'].toString()));
      //   item.LastDate = DateTime.fromMillisecondsSinceEpoch(
      //       int.parse(si.data['lastDate'].toString()));

      //   item.DaysOfWeek = days;
      //   sched.add(item);
      // }
      // tm.Schedule = new Schedule.withItems(sched);

      //tm.Months.Months[month] = await getMonthFromCloudForUser(month, userid);

      tm.Days.days[daykey] = await getDayFromCloudForUser(today, userid);
    }
  }

  return t;
}
