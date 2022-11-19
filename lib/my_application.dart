import 'package:cripto_flutter/widgets/auth_check.dart';
import 'package:flutter/material.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Criptomoedas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const AuthCheck(),
    );
  }
}
