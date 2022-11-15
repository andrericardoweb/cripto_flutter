import 'dart:collection';

import 'package:cripto_flutter/models/coin.dart';
import 'package:flutter/material.dart';

class FavoritesRepository extends ChangeNotifier {
  List<Coin> _listCoin = [];

  UnmodifiableListView<Coin> get listCoin => UnmodifiableListView(_listCoin);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_listCoin.contains(coin)) _listCoin.add(coin);
    });
    notifyListeners();
  }

  remove(Coin coin) {
    _listCoin.remove(coin);
    notifyListeners();
  }
}
