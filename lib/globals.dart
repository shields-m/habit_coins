library habit_coins.globals;

import 'package:habit_coins/schedule.dart';
import 'package:intl/intl.dart';

import 'models.dart';



bool ScheduleLoaded = false;
bool DaysLoaded = false;

Schedule mainSchedule = new Schedule();

DayList days = new DayList();

bool UseCloudSync;

String CurrentUser = '';

String getDayKey(DateTime dt)
{
  String d = NumberFormat('0000').format(dt.year) + NumberFormat('00').format(dt.month) +NumberFormat('00').format(dt.day) ;

  return d;
}