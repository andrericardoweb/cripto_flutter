import 'package:cripto_flutter/models/moeda.dart';

class MoedaRepository {
  static List<Moeda> table = [
    Moeda(
        icon: 'assets/images/bitcoin.png',
        name: 'Bitcoin',
        abbreviation: 'BTC',
        price: 164603.25),
    Moeda(
        icon: 'assets/images/ethereum.png',
        name: 'Ethereum',
        abbreviation: 'ETH',
        price: 9716.00),
    Moeda(
        icon: 'assets/images/xrp.png',
        name: 'XRP',
        abbreviation: 'XRP',
        price: 3.34),
    Moeda(
        icon: 'assets/images/cardano.png',
        name: 'Cardano',
        abbreviation: 'ADA',
        price: 6.32),
    Moeda(
        icon: 'assets/images/usdcoin.png',
        name: 'USD Coin',
        abbreviation: 'USDC',
        price: 5.02),
    Moeda(
        icon: 'assets/images/litecoin.png',
        name: 'Litecoin',
        abbreviation: 'LTC',
        price: 669.93),
  ];
}
