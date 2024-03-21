import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  static Database? _db;

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    await db.execute(
        "CREATE TABLE Contact(id INTEGER PRIMARY KEY, name TEXT, phone_number TEXT)");
  }

  Future<int> saveContact(Map<String, dynamic> contact) async {
    var dbClient = await db;
    int res = await dbClient.insert("Contact", contact);
    return res;
  }

  Future<List<Map<String, dynamic>>> getAllContacts() async {
    var dbClient = await db;
    var res = await dbClient.query("Contact");
    return res;
  }

  Future<int> saveUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user);
    return res;
  }

  Future<Map<String, dynamic>?> getUser(String username) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM User WHERE username = ?", [username]);
    return res.isNotEmpty ? res.first : null;
  }
  Future<int> deleteContact(int id) async {
    var dbClient = await db;
    return await dbClient.delete("Contact", where: "id = ?", whereArgs: [id]);
  }


  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient.delete("User", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient.update("User", user, where: "id = ?", whereArgs: [user["id"]]);
  }
}
