library habit_coins.globals;

import 'package:habit_coins/localData.dart';
import 'package:habit_coins/schedule.dart';

import 'models.dart';



bool ScheduleLoaded = false;
bool DaysLoaded = false;

Schedule mainSchedule = new Schedule();

DayList days = new DayList();