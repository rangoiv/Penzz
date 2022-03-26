import 'dart:io';

import 'package:flutter/material.dart';
import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/storage.dart';
import 'package:penzz/pages/scan_document_screen.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class DisplayDocumentsScreen extends StatefulWidget {
  static const String id = 'display_documents_screen';

  @override
  _DisplayDocumentsScreenState createState() => _DisplayDocumentsScreenState();
}
// TODO: riješiti glitch sa neucitavanjem
class _DisplayDocumentsScreenState extends State<DisplayDocumentsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tvoji dokumenti')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        // TODO: rijesiti glitch sa scrollanjem
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30,),

              FutureBuilder<List<Document>>(
                future: Documents.documents(),

                builder: (context, snapshot) {
                  List<Document> documents = [];
                  if (snapshot.hasData) {
                    documents = snapshot.data!;
                  }
                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];

                      return DocumentWidget(document: document, index: index,);
                    },
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

  void _scanDocument() async {
    Navigator.pushNamed(context, ScanDocumentScreen.id);
  }
}

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    Key? key,
    required this.document,
    required this.index
  }) : super(key: key);

  final Document document;
  final int index;

  Future<File> getDocument() async {
    File file = await Storage.getDocumentFile(document.id, document.name);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Dokument " + (index+1).toString() + ":", textAlign: TextAlign.center, textScaleFactor: 1.3,),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(document.name),
            // TODO: dodati preview na prvu stranicu
            ElevatedButton(
              onPressed: () => _onShare(context),
              child: const Text('Share'),
            )
          ],
        ),
      ),
    );

    /*
    return FutureBuilder<File> (
      future: getDocument(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          File file = snapshot.data!;


        }
        return ListTile(
          title: Text("Dokument " + (index+1).toString() + ":", textAlign: TextAlign.center, textScaleFactor: 1.3,),
        );
      },
    );
    */
  }

  void _onShare(BuildContext context) async {
    // TODO: urediti ovo
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareFiles(
        [(await Storage.getDocumentFile(document.id, document.name)).path],
        text: "moj tekst",
        subject: document.name,
        //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    );
  }
}