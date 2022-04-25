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

  const SaveDocumentScreen({Key? key}) : super(key: key);

  @override
  State<SaveDocumentScreen> createState() => _SaveDocumentScreenState();
}

class _SaveDocumentScreenState extends State<SaveDocumentScreen> {
  bool _firstBuild = true;
  List<String> _editedImages = [];
  bool _isImporting = false;

  String _documentType = kDocumentTypes[0];
  DateTime _documentDate = DateTime.now();
  String _documentName = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // get routes of scanned images from context when building the first time
    if (_firstBuild) {
      final args = ModalRoute.of(context)!.settings.arguments as SaveDocumentArguments;
      print("==== Save document screen ====");

      _editedImages += args.editedImages;
      _isImporting = args.isImporting;
      _firstBuild = false;

      print("Setting arguments");
      print(args.editedImages);
      print(args.documentDate);
      print(args.documentType);
      print(args.documentName);
      if (args.documentDate != null) {
        print("Setting Date");
        _documentDate = args.documentDate!;
      }
      if (args.documentName != null) {
        print("Setting Name");
        _documentName = args.documentName!;
      }
      if (args.documentType != null) {
        print("Setting Date");
        _documentType = args.documentType!;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tvoj novi dokument'),
        backgroundColor: const Color(0xff11121B),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: Colors.white,),
            onPressed: () {
              setState(() {
                _info();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16, 32, 0),
        child: ListView (
          children: <Widget>[
            Text("Unesite naziv dokumenta:"),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xff11121B),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  controller: new TextEditingController(text: _documentName),
                  onChanged: (value) {
                    _documentName = value;
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: kTextFieldDecoration.copyWith(
                    contentPadding: const EdgeInsets.all(0.0),
                    hintText: Document.getDefaultName(date: _documentDate, type: _documentType),
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),

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
            Text("Odaberite datum dokumenta:"),
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

            _isImporting ?
            Container(
                // Import button
            ) : ListView.builder( // Document list view
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: _editedImages.length,
              itemBuilder: (context, index) {
                final imagePath = _editedImages[index];

                return ListTile(
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Image.file(
                          File(imagePath),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                _onPageMoreActions(context, index);
                              },
                            ),
                          ),
                        ),
                      ],
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
          if (!this._isImporting) Container(
            margin: const EdgeInsets.all(10),
            child: BlackRoundButton(
              ht: "addImageFloatingButton",
              onPressed: _addPage,
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageMoreActions(BuildContext context, int index) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: new Text('Što želite napraviti sa ovom stranicom?'),
              ),
              ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Izbriši'),
                onTap: () async {
                  setState(() {
                    _removePage(index);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _removePage(int index) {
    _editedImages.removeAt(index);
  }

  void _addPage() async {
    // Close this window to scan new Image
    Navigator.pop(context, new SaveDocumentArguments(
      editedImages: _editedImages,
      documentName: _documentName,
      documentType: _documentType,
      documentDate: _documentDate,
    ));
  }

  Future _pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      helpText: "Odaberite datum",
      cancelText: "Natrag",
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
          ),
          child: child!,
        );
      },
    );

    if (newDate == null || newDate == _documentDate) return;

    setState(() => _documentDate = newDate);
  }

  void _info() async {

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

    if (_documentName=="") {
      _documentName = Document.getDefaultName(date: _documentDate, type: _documentType);
    }

    Document document = Document(
      id: await Documents.getNewId(),
      date: _documentDate,
      type: _documentType,
      name: _documentName,
    );

    final file = await Storage.getDocumentFile(document.id, document.name);
    print("Saving document on path: \n" + file.path);
    await file.writeAsBytes(await pdf.save());

    final imgPath = (await Storage.getDocumentImageFile(document.id, 0)).path;
    print("From path: \n" + _editedImages[0]);
    print("Saving document cover on path: \n" + imgPath);
    await File(_editedImages[0]).copy(imgPath);

    await Documents.insert(document);
  }
}

class SaveDocumentArguments {
  final List<String> editedImages;
  final String? documentName;
  final String? documentType;
  final DateTime? documentDate;

  final bool isImporting;

  SaveDocumentArguments({
    this.editedImages = const [],
    this.documentName,
    this.documentType,
    this.documentDate,

    this.isImporting = false
  });
}