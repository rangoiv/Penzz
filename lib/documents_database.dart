import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:penzz/storage.dart';
import 'dart:convert';

class Documents {
  static late Future<Database> database;
  static const _tableName = 'documents';
  static const _databaseName = 'documents_database.db';

  static Future<void> loadDatabase() async {
    database = _createDatabase();
    await database;
  }
  static Future<Database> _createDatabase() async {
    print("Opening Database for documents");
    WidgetsFlutterBinding.ensureInitialized();
    var path = join(await Storage.getUserDatabasesDirectory(), _databaseName);

    Future<void> _onCreate(Database db, int version) async {
      print("Creating - "+path);
      return db.execute(
        'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, name TEXT, date DATE, type TEXT)',
      );
    }
    Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
      print("Deleting - "+path);
      await db.execute(
        'DROP TABLE documents',
      );
      return _onCreate(db, newVersion);
    }
    final database = await openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
    return database;
  }
  static Future<void> close() async {
    print("Closing documents database");
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

  static Future<void> insertDocument(Document document) async {
    print("Inserting document in database - " + document.toString());
    final db = await database;

    await db.insert(
      'documents',
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<Document>> documents() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Document(
        id: maps[i]['id'],
        name: maps[i]['name'],
        date: DateTime.parse(maps[i]['date'].split("'")[3]),
        type: maps[i]['type'],
      );
    });
  }
}

class Document {
  final int id;
  late final String name;
  final DateTime date;
  final String type;

  Document({
    required this.id,
    String? name,
    required this.date,
    required this.type,
  }) {
    if (name == null || name == "") {
      name = this.type.replaceAll(" ", "_") + "-" + date.toString().split(' ')[0];
    }
    this.name = name;
  }

  Map<String, dynamic> toMap() {
    String d = date.toString().split(' ')[0];
    return {
      'id': id,
      'name': name,
      'date': "('DATE: Manual Date', '$d')",
      'type': type,
    };
  }
  @override
  String toString() {
    return 'Document{id: $id, name: $name, type: $type, date: $date}';
  }
}
