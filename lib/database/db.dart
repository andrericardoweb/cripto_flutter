import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  //Construtor com acesso privado
  DB._();

  //Criar uma instância de DB
  static final DB instance = DB._();

  //Instância do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cripto.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_historic);
    await db.insert('account', {'balance': 0});
  }

  String get _account => '''
    CREATE TABLE account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      balance REAL
    );
  ''';

  String get _wallet => '''
    CREATE TABLE wallet (
      abbreviation TEXT PRIMARY KEY,
      coin TEXT
      quantity TEXT
    );
  ''';

  String get _historic => '''
    CREATE TABLE historic (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date_operation INT,
      type_operation TEXT,
      coin TEXT,
      abbreviation TEXT,
      value REAL,
      quantity TEXT
    );
  ''';
}
