import 'package:cripto_flutter/configs/app_settings.dart';
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
  late NumberFormat real;
  late Map<String, String> loc;
  List<Coin> selected = [];
  late FavoritesRepository favorites;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$ ';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
            onTap: () {
              context.read<AppSettings>().setLocale(locale, name);
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  appBarDynamic() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Text('Criptomoedas'),
        actions: [changeLanguageButton()],
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
    readNumberFormat();

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
                if (favorites.listCoin.any((favorite) => favorite.abbreviation == table[coin].abbreviation))
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
