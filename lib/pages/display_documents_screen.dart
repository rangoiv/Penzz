import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:penzz/helpers/constants.dart';
import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/storage.dart';
import 'package:penzz/pages/scan_document_screen.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:penzz/widgets/black_round_button.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'package:open_file/open_file.dart';

class DisplayDocumentsScreen extends StatefulWidget {
  static const String id = 'display_documents_screen';

  @override
  _DisplayDocumentsScreenState createState() => _DisplayDocumentsScreenState();
}

class _DisplayDocumentsScreenState extends State<DisplayDocumentsScreen> {
  String _searchText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tvoji dokumenti'),
        backgroundColor: const Color(0xff11121B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30,),
              Material(
                color: const Color(0xff11121B),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 1,

                child: TextField(
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Traži',
                    hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,  fontFamily: 'Poppins-SemiBold'),
                    suffixIcon: Icon(Icons.search, color: Colors.white,),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30,),

              FutureBuilder<List<Document>>(
                future: Documents.documents(),

                builder: (context, snapshot) {
                  List<Document> documents = [];
                  if (snapshot.hasData) {
                    documents = snapshot.data!;
                  }
                  List<Document> filteredDocuments = [];
                  var searchText = _searchText.toLowerCase();

                  // If search bar is empty display all documents, otherwise search for the wanted item
                  if (searchText == "") {
                    filteredDocuments = documents;
                  } else {
                    for (var i = 0; i < documents.length; i++) {
                      final document = documents[i];
                      bool contains = true;
                      // Document is added if it contains all the words from search bar
                      for (var word in searchText.split(new RegExp(r'[. ]'))) {
                        if (!document.name.replaceAll("_", " ").replaceAll("-", " ").toLowerCase().contains(word) &&
                            !document.type.replaceAll("_", " ").toLowerCase().contains(word)) {
                          contains = false;
                          break;
                        }
                      }
                      if (contains) {
                        filteredDocuments.add(document);
                      }
                    }
                  }

                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final document = filteredDocuments[index];

                      return DocumentWidget(document: document, index: index,);
                    },
                  );
                },
              ),
            ]
        ),
      ),
      floatingActionButton: BlackRoundButton(onPressed: _scanDocument,),
    );
  }

  void _scanDocument() async {
    await Navigator.pushNamed(context, ScanDocumentScreen.id);
    setState(() {});
  }
}

class DocumentWidget extends StatelessWidget {
  DocumentWidget({
    Key? key,
    required this.document,
    required this.index
  }) : super(key: key);

  final Document document;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: Text(
              document.name,
              textAlign: TextAlign.center,
              textScaleFactor: 1,
            ),
            trailing: IconButton(
              onPressed: () => _onShare(context),
              iconSize: 20,
              icon: Icon(Icons.share, color: Colors.black,),
            ),
          ),
          // TODO: dodati preview na prvu stranicu
          GestureDetector(
            onTap: () async {
              var file = await document.getFile();
              OpenFile.open(file.path);
            },
            child: FutureBuilder<File>(
              future: () async {
                return document.getPageImage(0);
              }(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image(
                    image: FileImage(snapshot.data!),
                    height: 150,
                  );
                } else if (snapshot.hasError) {
                  print("Error opening preview for: " + document.name);
                }
                return Container(
                  height: 150,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onShare(BuildContext context) async {
    // TODO: urediti ovo
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareFiles(
        [(await Storage.getDocumentFile(document.id, document.name)).path],
        //text: "moj tekst",
        subject: document.name,
        //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    );
  }
}