import 'dart:async';
import 'dart:convert';

import 'package:cripto_flutter/database/db.dart';
import 'package:cripto_flutter/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class CoinRepository extends ChangeNotifier {
  List<Coin> _table = [];
  late Timer interval;

  List<Coin> get table => _table;

  CoinRepository() {
    _setupCoinRepository();
    _setupDataTableCoin();
    _readCoinsTable();
    _refreshPrices();
  }

  _refreshPrices() async {
    interval = Timer.periodic(const Duration(minutes: 5), (_) => checkPrices());
  }

  checkPrices() async {
    String uri = 'https://api.coinbase.com/v2/assets/prices?base=BRL';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> coins = json['data'];
      Database db = await DB.instance.database;
      Batch batch = db.batch();

      for (var current in _table) {
        for (var newest in coins) {
          if(current.baseId == newest['base_id']) {
            final coin = newest['prices'];
            final price = coin['latest_price'];
            final timestamp = DateTime.parse(price['timestamp']);

            batch.update(
              'coins',
              {
                'price': coin['latest'],
                'timestamp': timestamp.millisecondsSinceEpoch,
                'changeHour': price['percent_change']['hour'].toString(),
                'changeDay': price['percent_change']['day'].toString(),
                'changeWeek': price['percent_change']['week'].toString(),
                'changeMonth': price['percent_change']['month'].toString(),
                'changeYear': price['percent_change']['year'].toString(),
                'changeTotalPeriod': price['percent_change']['all'].toString()
              },
              where: 'baseId = ?',
              whereArgs: [current.baseId],
            );
          }
        }
      }
      await batch.commit(noResult: true);
      await _readCoinsTable();
    }
  }

  _readCoinsTable() async {
    Database db = await DB.instance.database;
    List results = await db.query('coins');

    _table = results.map((row) {
      return Coin(
        baseId: row['baseId'],
        icon: row['icon'],
        name: row['name'],
        abbreviation: row['abbreviation'],
        price: double.parse(row['price']),
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp']),
        changeHour: double.parse(row['changeHour']),
        changeDay: double.parse(row['changeDay']),
        changeWeek: double.parse(row['changeWeek']),
        changeMonth: double.parse(row['changeMonth']),
        changeYear: double.parse(row['changeYear']),
        changeTotalPeriod: double.parse(row['changeTotalPeriod']),
      );
    }).toList();

    notifyListeners();
  }

  _coinsTableIsEmpty() async {
    Database db = await DB.instance.database;
    List results = await db.query('coins');
    return results.isEmpty;
  }

  _setupDataTableCoin() async {
    if (await _coinsTableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> coins = json['data'];
        Database db = await DB.instance.database;
        Batch batch = db.batch();

        for (var coin in coins) {
          final preco = coin['latest_price'];
          final timestamp = DateTime.parse(preco['timestamp']);

          batch.insert('coins', {
            'baseId': coin['id'],
            'abbreviation': coin['symbol'],
            'name': coin['name'],
            'icon': coin['image_url'],
            'price': coin['latest'],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'changeHour': preco['percent_change']['hour'].toString(),
            'changeDay': preco['percent_change']['day'].toString(),
            'changeWeek': preco['percent_change']['week'].toString(),
            'changeMonth': preco['percent_change']['month'].toString(),
            'changeYear': preco['percent_change']['year'].toString(),
            'changeTotalPeriod': preco['percent_change']['all'].toString()
          });
        }
        await batch.commit(noResult: true);
      }
    }
  }

  _setupCoinRepository() async {
    const String table = '''
      CREATE TABLE IF NOT EXISTS coins (
        baseId TEXT PRIMARY KEY,
        abbreviation TEXT,
        name TEXT,
        icon TEXT,
        price TEXT,
        timestamp INTEGER,
        changeHour TEXT,
        changeDay TEXT,
        changeWeek TEXT,
        changeMonth TEXT,
        changeYear TEXT,
        changeTotalPeriod TEXT
      );
    ''';
    Database db = await DB.instance.database;
    await db.execute(table);
  }
}
