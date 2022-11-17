import 'package:cripto_flutter/database/db.dart';
import 'package:cripto_flutter/models/coin.dart';
import 'package:cripto_flutter/models/position.dart';
import 'package:cripto_flutter/repositories/coin_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<Position> _wallet = [];
  double _balance = 0;

  get balance => _balance;
  List<Position> get wallet => _wallet;

  AccountRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getBalance();
    await _getWallet();
  }

  _getBalance() async {
    db = await DB.instance.database;
    List account = await db.query('account', limit: 1);
    _balance = account.first['balance'];
    notifyListeners();
  }

  setBalance(double value) async {
    db = await DB.instance.database;
    db.update('account', {
      'balance': value,
    });
    _balance = value;
    notifyListeners();
  }

  buy(Coin coin, double value) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      // Verificar se a moeda já foi comprada
      final positionCoin = await txn.query(
        'wallet',
        where: 'abbreviation = ?',
        whereArgs: [coin.abbreviation],
      );

      // Se não tem a moeda em carteira
      if (positionCoin.isEmpty) {
        await txn.insert('wallet', {
          'abbreviation': coin.abbreviation,
          'coin': coin.name,
          'quantity': (value / coin.price).toString()
        });
      }
      //Já tem a moeda em carteira
      else {
        final currenty =
            double.parse(positionCoin.first['quantity'].toString());
        await txn.update(
          'wallet',
          {'quantity': (currenty + (value / coin.price)).toString()},
          where: 'abbreviation = ?',
          whereArgs: [coin.abbreviation],
        );
      }

      // Inserir a compra no histórico
      await txn.insert('historic', {
        'abbreviation': coin.abbreviation,
        'coin': coin.name,
        'quantity': (value / coin.price).toString(),
        'value': value,
        'type_operation': 'compra',
        'date_operation': DateTime.now().millisecondsSinceEpoch
      });

      // Atualizar o saldo
      await txn.update('account', {'balance': balance - value});
    });

    await _initRepository();
    notifyListeners();
  }

  _getWallet() async {
    _wallet = [];
    List positions = await db.query('wallet');
    for (var position in positions) {
      Coin coin = CoinRepository.table.firstWhere(
        (c) => c.abbreviation == position['abbreviation'],
      );
      _wallet.add(
        Position(
          coin: coin,
          quantity: double.parse(position['quantity']),
        ),
      );
    }
    notifyListeners();
  }
}