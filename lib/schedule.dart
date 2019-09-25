
import 'package:habit_coins/models.dart';

import 'models.dart';

import 'package:intl/intl.dart';



class ScheduleItem
{
  DateTime FirstDate;

  DateTime LastDate;

  List<String> DaysOfWeek;

  Coin HabitCoin;

  ScheduleItem()
  {
    DaysOfWeek = new List();
    LastDate = DateTime.utc(9999);
  }



}

class Schedule
{

  List<ScheduleItem> Items;

  Schedule(){
    Items = new List();

  }

  void AddItem(ScheduleItem item)
  {
    Items.add(item);
  }

  void RemoveItem(ScheduleItem item)
  {
    if(Items.contains(item))
      {
        Items.remove(item);
      }

  }

  List<Coin> getCoinsForDay(DateTime dateTime)
  {
    List<Coin> coins = new List();
    String weekday = DateFormat("EEEE").format(dateTime);
    //print(weekday);
    Items.forEach((item)=> {

      if(item.DaysOfWeek.contains(weekday) && dateTime.isAfter(item.FirstDate.add(Duration(days: -1))) && dateTime.isBefore(item.LastDate.add(Duration(days: 1))) ){
        coins.add(item.HabitCoin)

      }


    });

    return coins;

  }


}


