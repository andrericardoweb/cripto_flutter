import 'package:cripto_flutter/configs/app_settings.dart';
import 'package:cripto_flutter/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_application.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritesRepository()),
      ],
      child: const MyApplication(),
    ),
  );
}
