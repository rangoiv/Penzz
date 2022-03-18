
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:penzz/storage.dart';
import 'package:sqflite/sqflite.dart';

class Sugar {
  static late Future<Database> database;
  static final _tableName = 'Sugar';

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

  static Future<void> insert(Sug object) async {
    print("Inserting - " + object.toString());
    final db = await database;

    await db.insert(
      'Sugar', object.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
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
  String t = date.toString().split(' ')[0];
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
