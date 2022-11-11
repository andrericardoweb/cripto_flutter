import 'package:cripto_flutter/models/coin.dart';
import 'package:flutter/material.dart';

class CoinsDetailsPage extends StatefulWidget {
  Coin coin;

  CoinsDetailsPage({super.key, required this.coin});

  @override
  State<CoinsDetailsPage> createState() => _CoinsDetailsPageState();
}

class _CoinsDetailsPageState extends State<CoinsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: Column(
        children: [
          Image.asset(widget.coin.icon)
        ],
      ),
    );
  }
}
