import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  late SharedPreferences _preferences;

  Map<String, String> locale = {
    'locale': 'pt_BR',
    'name': 'R\$',
  };

  AppSettings() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    await _readLocale();
  }

  Future<void> _startPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  _readLocale() {
    final local = _preferences.getString('local') ?? 'pt_BR';
    final name = _preferences.getString('name') ?? 'R\$';
    locale = {
      'locale': local,
      'name': name,
    };
    notifyListeners();
  }

  setLocale(String local, String name) async {
    await _preferences.setString('local', local);
    await _preferences.setString('name', name);
    await _readLocale();
  }
}
