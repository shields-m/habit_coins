import 'dart:convert'; //to convert json to maps and vice versa

import 'package:habit_coins/models.dart';

class fileWriter {

  fileWriter(){}

  Future<String> saveFile(List<Coin> coins) async {
    JsonEncoder e = new JsonEncoder();
    String x = e.convert(coins);
    print(x);

    JsonDecoder d = new JsonDecoder();
    List<dynamic> xx = d.convert(x);

List<Coin> cs = xx.map((c) => new Coin.fromDynamic(c) ).toList();
    print(cs);

    return x;
  }
}
