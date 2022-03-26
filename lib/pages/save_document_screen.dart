import 'dart:io';
import 'dart:async';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:penzz/pages/scan_document_screen.dart';
import 'package:penzz/helpers/storage.dart';
import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/constants.dart';

class SaveDocumentScreen extends StatefulWidget {
  static const String id = 'save_document_screen';

  const SaveDocumentScreen({Key? key}) : super(key: key);

  @override
  State<SaveDocumentScreen> createState() => _SaveDocumentScreenState();
}

class _SaveDocumentScreenState extends State<SaveDocumentScreen> {
  List<String> _editedImages = [];
  bool _firstBuild = true;
  String _documentType = kDocumentTypes[0];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get routes of scanned images from context when building the first time
    if (_firstBuild) {
      var newEditedImages = ModalRoute.of(context)!.settings.arguments as List<String>;
      _editedImages += newEditedImages;
      _firstBuild = false;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Your new document')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: ListView (
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 10),
            child: DropdownButton<String>(
              value: _documentType,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _documentType = newValue!;
                });
              },
              items: kDocumentTypes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
            ),
          ),
          ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _editedImages.length,
            itemBuilder: (context, index) {
              final imagePath = _editedImages[index];

              return ListTile(
                title: Text("Image " + (index+1).toString() + ":", textAlign: TextAlign.center, textScaleFactor: 1.3,),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
                  child: Image.file(
                    File(imagePath),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: FloatingActionButton(
              heroTag: "doneFloatingButton",
              onPressed: _done,
              child: const Icon(Icons.check),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              heroTag: "addImageFloatingButton",
              onPressed: _addImage,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _addImage() async {
    // open window for scanning images and get their routes
    final newEditedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanDocumentScreen(launchedFromDisplayDocument: true),
      ),
    );
    setState(() { _editedImages += newEditedImages; });
  }

  void _done() async {
    if (_editedImages.isEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Upozorenje"),
            content: Text("Dokument je prazan i neće biti spremljen!", style: TextStyle(fontFamily: 'NotoSans'),),
            actions: [
              TextButton(
                child: Text("OK", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      await _saveDocument();
    }
    Navigator.pop(context);
  }

  Future<void> _saveDocument() async {
    print("Creating pdf document.");
    final pdf = pw.Document();

    for (var imagePath in _editedImages) {
      final image = pw.MemoryImage(
        File(imagePath).readAsBytesSync(),
      );
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          }));
    }

    Document document = Document(
      id: await Documents.getNewId(),
      date: DateTime.now(),
      type: _documentType,
    );

    final file = await Storage.getDocumentFile(document.id, document.name);
    print("Saving document on path: \n" + file.path);
    await file.writeAsBytes(await pdf.save());

    await Documents.insertDocument(document);
  }
}
