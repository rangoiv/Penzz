import 'package:flutter/material.dart';
import 'package:penzz/documents_database.dart';
import 'package:penzz/storage.dart';
import 'package:penzz/pages/scan_document_screen.dart';


class DisplayDocumentsScreen extends StatefulWidget {
  static const String id = 'display_documents_screen';

  @override
  _DisplayDocumentsScreenState createState() => _DisplayDocumentsScreenState();
}

class _DisplayDocumentsScreenState extends State<DisplayDocumentsScreen> {
  List<Document> _documents = [];

  @override
  void initState() {
    super.initState();

    _begin();
  }

  void _begin() async {
    await Storage.loadUser();
    await Documents.loadDatabase();

    await Documents.insertDocument(Document(
        id: 1,
        name: "Prvi",
        date: DateTime.now(),
        type: "Uputnica",
    ));
    await Documents.insertDocument(Document(
      id: 2,
      name: "Drugi dokument",
      date: DateTime.now(),
      type: "Uputnica",
    ));
    await Documents.insertDocument(Document(
      id: 3,
      name: "Treći dokument",
      date: DateTime(0),
      type: "Uputnica",
    ));
    _documents = await Documents.documents();
    setState(() {});
  }

  void _scanDocument() async {
    // TODO: Nakon skeniranja se ne učita novi dokument
    Navigator.pushNamed(context, ScanDocumentScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tvoji dokumenti')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30,),
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _documents.length,
                itemBuilder: (context, index) {
                  final document = _documents[index];

                  return ListTile(
                    title: Text("Dokument " + (index+1).toString() + ":", textAlign: TextAlign.center, textScaleFactor: 1.3,),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      child: Text(document.type + " / " + document.name),
                    ),
                  );
                },
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanDocument,
        tooltip: 'Scan document',
        child: const Icon(Icons.add),
      ),
    );
  }
}
