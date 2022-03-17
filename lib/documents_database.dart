import 'dart:io';
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:penzz/storage.dart';


class Documents {
  static late Future<Database> database;
  static const _tableName = 'documents';

  static Future<void> loadDatabase() async {
    database = _createDatabase();
    await database;
  }
  static Future<Database> _createDatabase() async {
    print("Opening Database for documents");
    WidgetsFlutterBinding.ensureInitialized();
    var path = join(await Storage.getUserDatabasesDirectory(), 'documents_database.db');

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

    final database = openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
    return database;
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
        date: DateTime.parse(maps[i]['date'].split("'")[3]), // TODO:
        type: maps[i]['type'],
      );
    });
  }
}

class Document {
  final int id;
  final String name;
  final DateTime date;
  final String type;

  const Document({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
  });

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
