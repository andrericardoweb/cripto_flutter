import 'package:cripto_flutter/repositories/favorites_repository.dart';
import 'package:cripto_flutter/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptos Favoritas'),
      ),
      body: Container(
          color: Colors.indigo.withOpacity(0.05),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(12.0),
          child: Consumer<FavoritesRepository>(
            builder: (context, favorites, child) {
              return favorites.listCoin.isEmpty
                  ? const ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Ainda não há moedas favoritas'),
                    )
                  : ListView.builder(
                      itemCount: favorites.listCoin.length,
                      itemBuilder: (_, index) {
                        return  CoinCard(coin: favorites.listCoin[index]);
                      },
                    );
            },
          )),
    );
  }
}
