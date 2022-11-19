import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_flutter/database/db_firestore.dart';
import 'package:cripto_flutter/models/coin.dart';
import 'package:cripto_flutter/repositories/coin_repository.dart';
import 'package:cripto_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Coin> _listCoin = [];
  late FirebaseFirestore db;
  late AuthService auth;

  FavoritesRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readFavorites();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readFavorites() async {
    if (auth.userLogged != null && _listCoin.isEmpty) {
      final snapshot =
          await db.collection('users/${auth.userLogged!.uid}/favorites').get();

      for (var doc in snapshot.docs) {
        Coin coin = CoinRepository.table
            .firstWhere((coin) => coin.abbreviation == doc.get('abbreviation'));
        _listCoin.add(coin);
        notifyListeners();
      }
    }
  }

  UnmodifiableListView<Coin> get listCoin => UnmodifiableListView(_listCoin);

  saveAll(List<Coin> coins) async {
    for (var coin in coins) {
      if (!_listCoin
          .any((currenty) => currenty.abbreviation == coin.abbreviation)) {
        _listCoin.add(coin);
        await db
            .collection('users/${auth.userLogged!.uid}/favorites')
            .doc(coin.abbreviation)
            .set({
          'coin': coin.name,
          'abbreviation': coin.abbreviation,
          'price': coin.price,
        });
      }
    }
    notifyListeners();
  }

  remove(Coin coin) async {
    await db
        .collection('users/${auth.userLogged!.uid}/favorites')
        .doc(coin.abbreviation)
        .delete();
    _listCoin.remove(coin);

    notifyListeners();
  }
}
