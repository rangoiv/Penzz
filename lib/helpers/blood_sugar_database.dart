import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:penzz/helpers/storage.dart';
import 'package:sqflite/sqflite.dart';

class Sugar {
  static late Future<Database> database;
  static final _tableName = 'Sugar';
  static const _databaseName='sugar_database.db';

  static Future<void> loadDatabase() async {
    database = _createDatabase();
    await database;
  }

  static Future<Database> _createDatabase() async {
    print("Opening db for blood sugar");
    WidgetsFlutterBinding.ensureInitialized();
    var path = join(await Storage.getUserDatabasesDirectory(), 'sugar_database.db');

    Future<void> _onCreate(Database db, int version) async {
      print("Creating -" + path);
      return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, sugar_value INTEGER, date DATE)');
    }

    Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
      print("Deleting -" + path);

      await db.execute(
        'DROP TABLE documents',
      );
      return _onCreate(db, newVersion);
    }

    database = openDatabase(
      path, onCreate: _onCreate, onUpgrade: _onUpgrade, version: 1,);

    return database;
  }

  static Future<void> close() async {
    print("Closing blood sugar database");
    final db = await database;
    await db.close();
  }

  static Future<void> deleteDatabase() async {
    try {
      var path = join(await Storage.getUserDatabasesDirectory(), _databaseName);
      print("Deleting database - " + path);
      final file = File(path);

      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  static Future<int> getNewId() async {
    final db = await database;

    // Get the highest id currently used in database
    print("Getting new id");
    var res = await db.query(_tableName, columns: ["MAX(id)"]);
    var newId = res[0]["MAX(id)"];

    if (newId == null) {
      return 100000;
    }
    int newIdInt = int.parse(newId.toString()) + 1;
    return newIdInt;
  }

  static Future<void> insert(Sug object) async {
    print("Inserting - " + object.toString());
    final db = await database;

    await db.insert(
      'Sugar', object.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  static Future<void> delete(int id) async{
    print("Deleting - " + id.toString());
    final db = await database;
    try{
      await db.delete('Sugar', where: 'id = ?', whereArgs: [id]);
    }
    catch(e){
      debugPrint("Something went wrong!");
    }
  }

  static Future<List<Sug>> queryAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Sug(
        id: maps[i]['id'],
        sugar_value: maps[i]['sugar_value'],
        date: DateTime.parse(maps[i]['date'].split("'")[3]),
      );
    });
  }
}
  class Sug{
  final int id;
  final int sugar_value;
  final DateTime date;

  const Sug({
  required this.id,
  required this.sugar_value,
  required this.date,
  });

  Map<String, dynamic> toMap(){
  String t = date.toIso8601String();//toString().split(' ')[0];
  return{
  'id' : id,
  'sugar_value':sugar_value,
  'date': "('DATE: Manual Date', '$t')",
  };
  }

  @override
  String toString(){
  return 'Document{id: $id, sugar_value: $sugar_value, date: $date}';
  }
}
