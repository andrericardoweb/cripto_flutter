import 'package:cripto_flutter/models/coin.dart';
import 'package:cripto_flutter/pages/coins_details_page.dart';
import 'package:cripto_flutter/repositories/coin_repository.dart';
import 'package:cripto_flutter/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({super.key});

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  final table = CoinRepository.table;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Coin> selected = [];
  late FavoritesRepository favorites;

  appBarDynamic() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Text('Criptomoedas'),
      );
    } else {
      return AppBar(
        leading: IconButton(
            onPressed: cleanSelected, icon: const Icon(Icons.arrow_back)),
        title: Text(
          '${selected.length} selecionadas',
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      );
    }
  }

  showDetails(Coin coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinsDetailsPage(coin: coin),
      ),
    );
  }

  cleanSelected() {
    setState(() {
      selected = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    favorites = Provider.of<FavoritesRepository>(context);

    return Scaffold(
      appBar: appBarDynamic(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int coin) {
          return ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            leading: (selected.contains(table[coin]))
                ? const CircleAvatar(
                    child: Icon(Icons.check),
                  )
                : SizedBox(width: 40, child: Image.asset(table[coin].icon)),
            title: Row(
              children: [
                Text(
                  table[coin].name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
                if (favorites.listCoin.contains(table[coin]))
                  const Icon(Icons.circle, color: Colors.amber, size: 8)
              ],
            ),
            trailing: Text(real.format(table[coin].price)),
            selected: selected.contains(table[coin]),
            selectedTileColor: Colors.indigo[50],
            onLongPress: () {
              setState(() {
                (selected.contains(table[coin]))
                    ? selected.remove(table[coin])
                    : selected.add(table[coin]);
              });
            },
            onTap: () => showDetails(table[coin]),
          );
        },
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: table.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (selected.isNotEmpty)
          ? FloatingActionButton.extended(
              onPressed: () {
                favorites.saveAll(selected);
                cleanSelected();
              },
              icon: const Icon(Icons.favorite),
              label: const Text(
                'FAVORITAR',
                style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
