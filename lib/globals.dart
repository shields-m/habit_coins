library habit_coins.globals;

import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';

import 'models.dart';

Map<String,Person> people = new Map();
bool playSounds = true;
bool ScheduleLoaded = false;
bool DaysLoaded = false;
bool MonthsLoaded = false;

Schedule mainSchedule = new Schedule();

MonthsList monthsList = new MonthsList();

DayList days = new DayList();

bool UseCloudSync = false;

bool ShowHelp = false;

String CurrentUser = '';

//String TeamID = '';

UserDetails userDetails = new UserDetails();

Team myTeam;

String getDayKey(DateTime dt)
{
  String d = NumberFormat('0000').format(dt.year) + NumberFormat('00').format(dt.month) +NumberFormat('00').format(dt.day) ;

  return d;
}