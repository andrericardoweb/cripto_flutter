import 'dart:collection';

import 'package:cripto_flutter/adapters/coin_hive_adapter.dart';
import 'package:cripto_flutter/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Coin> _listCoin = [];
  late LazyBox box;

  FavoritesRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavorites();
  }

  _openBox() async {
    Hive.registerAdapter(CoinHiveAdapter());
    box = await Hive.openLazyBox<Coin>('favorite_coins');
  }

  _readFavorites() async {
    for (var coin in box.keys) {
      Coin c = await box.get(coin);
      _listCoin.add(c);
      notifyListeners();
    }
  }

  UnmodifiableListView<Coin> get listCoin => UnmodifiableListView(_listCoin);

  saveAll(List<Coin> coins) {
    for (var coin in coins) {
      if (!_listCoin
          .any((currenty) => currenty.abbreviation == coin.abbreviation)) {
        _listCoin.add(coin);
        box.put(coin.abbreviation, coin);
      }
    }
    notifyListeners();
  }

  remove(Coin coin) {
    _listCoin.remove(coin);
    box.delete(coin.abbreviation);
    notifyListeners();
  }
}
