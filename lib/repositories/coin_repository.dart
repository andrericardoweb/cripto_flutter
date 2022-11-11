import 'package:cripto_flutter/models/coin.dart';

class CoinRepository {
  static List<Coin> table = [
    Coin(
        icon: 'assets/images/bitcoin.png',
        name: 'Bitcoin',
        abbreviation: 'BTC',
        price: 164603.25),
    Coin(
        icon: 'assets/images/ethereum.png',
        name: 'Ethereum',
        abbreviation: 'ETH',
        price: 9716.00),
    Coin(
        icon: 'assets/images/xrp.png',
        name: 'XRP',
        abbreviation: 'XRP',
        price: 3.34),
    Coin(
        icon: 'assets/images/cardano.png',
        name: 'Cardano',
        abbreviation: 'ADA',
        price: 6.32),
    Coin(
        icon: 'assets/images/usdcoin.png',
        name: 'USD Coin',
        abbreviation: 'USDC',
        price: 5.02),
    Coin(
        icon: 'assets/images/litecoin.png',
        name: 'Litecoin',
        abbreviation: 'LTC',
        price: 669.93),
  ];

}
