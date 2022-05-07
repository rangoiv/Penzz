import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:penzz/helpers/storage.dart';
import 'package:sqflite/sqflite.dart';

class Pressure {
  static late Future<Database> database;
  static final _tableName = 'Pressure';
  static const _databaseName='pressure_database.db';

  static Future<void> loadDatabase() async {
    database = _createDatabase();
    await database;
  }

  static Future<Database> _createDatabase() async {
    print("Opening db for blood pressure");
    WidgetsFlutterBinding.ensureInitialized();
    var path = join(await Storage.getUserDatabasesDirectory(), 'pressure_database.db');

    Future<void> _onCreate(Database db, int version) async {
      print("Creating -" + path);
      return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, systolic_pressure_value DOUBLE, diastolic_pressure_value DOUBLE, date DATE)');
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
    print("Closing blood pressure database");
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

  static Future<void> insert(Press object) async {
    print("Inserting - " + object.toString());
    final db = await database;

    await db.insert(
      'Pressure', object.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  static Future<void> delete(int id) async{
    print("Deleting - " + id.toString());
    final db = await database;
    try{
      await db.delete('Pressure', where: 'id = ?', whereArgs: [id]);
    }
    catch(e){
      debugPrint("Something went wrong!");
    }
  }

  static Future<List<Press>> queryAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Press(
        id: maps[i]['id'],
        systolic_pressure_value: maps[i]['systolic_pressure_value'],
        diastolic_pressure_value: maps[i]['diastolic_pressure_value'],
        date: DateTime.parse(maps[i]['date'].split("'")[3]),
      );
    });
  }
}
class Press{
  final int id;
  final double systolic_pressure_value;
  final double diastolic_pressure_value;
  final DateTime date;

  const Press({
    required this.id,
    required this.systolic_pressure_value,
    required this.diastolic_pressure_value,
    required this.date,
  });

  Map<String, dynamic> toMap(){
    String t = date.toIso8601String();//toString().split(' ')[0];
    return{
      'id' : id,
      'systolic_pressure_value':systolic_pressure_value,
      'diastolic_pressure_value':diastolic_pressure_value,
      'date': "('DATE: Manual Date', '$t')",
    };
  }

  @override
  String toString(){
    return 'Document{id: $id, systolic_pressure_value: $systolic_pressure_value,diastolic_pressure_value:$diastolic_pressure_value,'
        ' date: $date}';
  }
}