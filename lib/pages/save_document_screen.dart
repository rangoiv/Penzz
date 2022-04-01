import 'dart:io';
import 'dart:async';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:penzz/pages/scan_document_screen.dart';
import 'package:penzz/helpers/storage.dart';
import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/constants.dart';
import 'package:penzz/widgets/black_round_button.dart';
import 'package:intl/intl.dart';

class SaveDocumentScreen extends StatefulWidget {
  static const String id = 'save_document_screen';
  final List<String> editedImages;

  const SaveDocumentScreen({Key? key, this.editedImages = const []}) : super(key: key);

  @override
  State<SaveDocumentScreen> createState() => _SaveDocumentScreenState();
}

class _SaveDocumentScreenState extends State<SaveDocumentScreen> {
  List<String> editedImages;
  bool _firstBuild = true;
  String _documentType = kDocumentTypes[0];
  DateTime _documentDate = DateTime.now();

  _SaveDocumentScreenState({this.editedImages = const []});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get routes of scanned images from context when building the first time

    if (_firstBuild) {
      var newEditedImages = ModalRoute.of(context)!.settings.arguments as List<String>;
      editedImages += newEditedImages;
      _firstBuild = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tvoj novi dokument'),
        backgroundColor: const Color(0xff11121B),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16, 32, 0),
        child: ListView (
          children: <Widget>[
            Text("Odaberite tip dokumenta:"),
            // Document type selector
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),

              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 36,
                decoration: BoxDecoration(
                    color: const Color(0xff11121B),
                    borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _documentType,
                    icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.white,),
                    elevation: 16,
                    dropdownColor: const Color(0xff11121B),
                    underline: null,
                    onChanged: (String? newValue) {
                      setState(() {
                        _documentType = newValue!;
                      });
                    },
                    items: kDocumentTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.center,
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.white),), //, style: const TextStyle(fontSize: 16, color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4),
            Text("Odaberite Datum:"),
            // Date selection button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff11121B),
                ),
                child: Text("Datum: " + DateFormat('MM/dd/yyyy').format(_documentDate)),
                onPressed: () => _pickDate(context),
              ),
            ),
            SizedBox(height: 16),

            // Document list view
            ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: editedImages.length,
              itemBuilder: (context, index) {
                final imagePath = editedImages[index];

                return ListTile(
                  //title: Text("Image " + (index+1).toString() + ":", textAlign: TextAlign.center, textScaleFactor: 1.3,),
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
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: BlackRoundButton(
              ht: "doneFloatingButton",
              onPressed: _done,
              icon: const Icon(Icons.check),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: BlackRoundButton(
              ht: "addImageFloatingButton",
              onPressed: _addImage,
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _addImage() async {
    // Close this window to scan new Image
    Navigator.pop(context, editedImages);
  }

  Future _pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _documentDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff11121B),
            colorScheme: ColorScheme.light(
              primary: const Color(0xff11121B),
            ),
            //buttonTheme: ButtonThemeData(
            //    textTheme: ButtonTextTheme.primary
            //),
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    setState(() => _documentDate = newDate);
  }

  void _done() async {
    if (editedImages.isEmpty) {
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

    for (var imagePath in editedImages) {
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
      date: _documentDate,
      type: _documentType,
    );

    final file = await Storage.getDocumentFile(document.id, document.name);
    print("Saving document on path: \n" + file.path);
    await file.writeAsBytes(await pdf.save());

    final imgPath = (await Storage.getDocumentImageFile(document.id, 0)).path;
    print("From path: \n" + editedImages[0]);
    print("Saving document cover on path: \n" + imgPath);
    await File(editedImages[0]).copy(imgPath);

    await Documents.insertDocument(document);
  }
}
