import 'package:cripto_flutter/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';

class MoedasPage extends StatelessWidget {
  const MoedasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final table = MoedaRepository.table;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptomoedas'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            leading: Image.asset(table[moeda].icon),
            title: Text(table[moeda].name),
            trailing: Text(table[moeda].price.toString()),
          );
        },
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: table.length,
      ),
    );
  }
}
