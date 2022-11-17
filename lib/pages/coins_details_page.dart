import 'package:cripto_flutter/configs/app_settings.dart';
import 'package:cripto_flutter/models/coin.dart';
import 'package:cripto_flutter/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinsDetailsPage extends StatefulWidget {
  final Coin coin;

  const CoinsDetailsPage({super.key, required this.coin});

  @override
  State<CoinsDetailsPage> createState() => _CoinsDetailsPageState();
}

class _CoinsDetailsPageState extends State<CoinsDetailsPage> {
  late NumberFormat real;
  late Map<String, String> loc;
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  double quantity = 0;
  late AccountRepository account;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  buy() async {
    if (_form.currentState!.validate()) {
      //Salvar a compra
      await account.buy(widget.coin, double.parse(_value.text));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra realizada com sucesso!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();
    account = Provider.of<AccountRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset(widget.coin.icon),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    real.format(widget.coin.price),
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        color: Colors.grey[800]),
                  )
                ],
              ),
            ),
            (quantity > 0)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(12.0),
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                      child: Text(
                        '$quantity ${widget.coin.abbreviation}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.teal),
                      ),
                    ),
                  )
                : const SizedBox(height: 24),
            Form(
              key: _form,
              child: TextFormField(
                controller: _value,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text(
                    'reais',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'Compra mínima de R\$50,00';
                  } else if (double.parse(value) > account.balance) {
                    return 'Você não tem saldo suficiente';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantity = value.isEmpty
                        ? 0
                        : double.parse(value) / widget.coin.price;
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                  onPressed: buy,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Comprar',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
