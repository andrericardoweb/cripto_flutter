import 'package:cripto_flutter/models/coin.dart';

class Historic {
  DateTime dateOperation;
  String typeOperation;
  Coin coin;
  double value;
  double quantity;

  Historic({
    required this.dateOperation,
    required this.typeOperation,
    required this.coin,
    required this.value,
    required this.quantity,
  });
}
