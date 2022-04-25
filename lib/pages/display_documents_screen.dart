import 'dart:io';
import 'package:flutter/material.dart';
import 'package:penzz/pages/save_document_screen.dart';

import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';

import 'package:penzz/helpers/constants.dart';
import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/storage.dart';
import 'package:penzz/pages/scan_document_screen.dart';
import 'package:penzz/widgets/background.dart';
import 'package:penzz/widgets/black_round_button.dart';

class DisplayDocumentsScreen extends StatefulWidget {
  static const String id = 'display_documents_screen';

  @override
  _DisplayDocumentsScreenState createState() => _DisplayDocumentsScreenState();
}

class _DisplayDocumentsScreenState extends State<DisplayDocumentsScreen> {
  String _searchText = "";
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: !_isSearching ? const Text('Tvoji dokumenti') : _searchTextField(),
        backgroundColor: const Color(0xff11121B),
        actions: !_isSearching ? [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white,),
            onPressed: () {
              _onMoreActions(context);
            },
          ),
        ] : [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchText = "";
              });
            },
          ),
        ],
      ),
      body: Background(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<Document>>(
            future: Documents.documents(),

            builder: (context, snapshot) {
              List<Document> documents = [];
              if (snapshot.hasData) {
                documents = snapshot.data!;
              }

              return _gridWidget(_filterDocuments(documents));
            },
          ),
        ),
      ),
      floatingActionButton: BlackRoundButton(onPressed: _scanDocument,),
    );
  }

  List<Document> _filterDocuments(List<Document> documents) {
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
    return filteredDocuments;
  }

  Widget _gridWidget(List<Document> documents) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
      ),
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];

        return DocumentWidget(
          document: document,
          index: index,
          reload: () {setState(() {});},
        );
      },
    );
  }

  Widget _searchTextField() {
    return TextField(
      style: TextStyle(color: Colors.white,),
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        setState(() {
          _searchText = value;
        });
      },
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Traži',
        hintStyle: TextStyle(
          color: Colors.white
        ),
        //suffixIcon: Icon(Icons.search, color: Colors.white,),
      ),
      textAlign: TextAlign.left,
    );
  }

  void _onMoreActions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: new Text('Dodatne opcije'),
            ),
            ListTile(
              leading: new Icon(Icons.upload_file),
              title: new Text('Dodaj pdf dokument'),
              onTap: () async {
                await _importDocument();
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
  }
  Future<void> _importDocument() async {
    await Navigator.pushNamed(
      context,
      SaveDocumentScreen.id,
      arguments: SaveDocumentArguments(
        isImporting: true,
      ),
    );
    setState(() {});
  }

  Future<void> _scanDocument() async {
    // TODO: dodati za ne prikazivati ponovno
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Molimo dokument uslikajte odozgora tako da se rubovi slažu uz rub ekrana.'),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    await Navigator.pushNamed(context, ScanDocumentScreen.id);
    setState(() {});
  }
}

// Widget for one document card
class DocumentWidget extends StatelessWidget {
  DocumentWidget({
    Key? key,
    required this.document,
    required this.index,
    required this.reload,
  }) : super(key: key);

  final Document document;
  final int index;
  final void Function()? reload;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xff11121B),
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 8, top: 2, bottom: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      document.name,
                      textAlign: TextAlign.left,
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      document.date.toString().split(' ')[0],
                      textAlign: TextAlign.left,
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _onDocumentMoreActions(context),
                  iconSize: 20,
                  icon: Icon(Icons.more_vert, color: Colors.white,),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Stack(
            fit: StackFit.expand,

            children: <Widget>[
              FutureBuilder<File>(
                future: () async {
                  return document.getPageImage(0);
                }(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: Image(
                        image: FileImage(snapshot.data!),
                      ),
                    );
                  }
                  return Container(
                    color: Colors.grey,
                  );
                },
              ),

              Positioned.fill(
                child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    var file = await document.getFile();
                      OpenFile.open(file.path);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onDocumentMoreActions(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: new Text('Što želite napraviti s dokumentom?'),
              ),
              ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Izbriši'),
                onTap: () async {
                  await _onDocumentDelete(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('Podijeli'),
                onTap: () async {
                  await _onDocumentShare(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _onDocumentDelete(BuildContext context) async {
    bool doDelete = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Jeste li sigurni da želite izbrisati dokument?'),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Natrag'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Izbriši'),
          ),
        ],
      ),
    );
    if (doDelete) {
      await Documents.delete(document.id);

      if (reload != null) {
        reload!();
      };
    }
  }
  Future<void> _onDocumentShare(BuildContext context) async {
    await Share.shareFiles(
        [(await Storage.getDocumentFile(document.id, document.name)).path],
        subject: document.name,
    );
  }
}