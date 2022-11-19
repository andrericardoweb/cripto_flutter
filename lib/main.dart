import 'package:cripto_flutter/configs/app_settings.dart';
import 'package:cripto_flutter/repositories/account_repository.dart';
import 'package:cripto_flutter/repositories/favorites_repository.dart';
import 'package:cripto_flutter/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'configs/hive_config.dart';
import 'my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => AccountRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
          create: (context) =>
              FavoritesRepository(auth: context.read<AuthService>()),
        ),
      ],
      child: const MyApplication(),
    ),
  );
}
