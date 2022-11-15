import 'package:cripto_flutter/models/coin.dart';
import 'package:cripto_flutter/pages/coins_details_page.dart';
import 'package:cripto_flutter/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinCard extends StatefulWidget {
  Coin coin;
  CoinCard({super.key, required this.coin});

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  static Map<String, Color> priceColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.indigo,
  };

  showDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinsDetailsPage(coin: widget.coin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12.0),
      elevation: 2,
      child: InkWell(
        onTap: () => showDetails(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              Image.asset(
                widget.coin.icon,
                height: 40,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.coin.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(widget.coin.abbreviation,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                    color: priceColor['down']!.withOpacity(0.05),
                    border: Border.all(
                      color: priceColor['down']!.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  real.format(widget.coin.price),
                  style: TextStyle(
                    fontSize: 16,
                    color: priceColor['down'],
                    letterSpacing: -1,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: Text('Remover das Favoritas'),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<FavoritesRepository>(context, listen: false)
                            .remove(widget.coin);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
