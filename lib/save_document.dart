import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/widgets.dart';


import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void createDatabase() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
  );
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
  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'type': type,
    };
  }
  @override
  String toString() {
    return 'Document{id: $id, name: $name, type: $type, date: $date}';
  }
}



// TODO: Make it work for Files array (when document has multiple pages)
Future<void> saveDocument(File imageFile) async {
  // Assemble the document
  final pdf = pw.Document();

  final image = pw.MemoryImage(
    imageFile.readAsBytesSync(),
  );

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        );
      }));

  final file = File(await getFilePath("example.pdf"));
  await file.writeAsBytes(await pdf.save());

}

Future<String> getFilePath(String fileName) async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  String filePath = '$appDocumentsPath/$fileName';

  return filePath;
}