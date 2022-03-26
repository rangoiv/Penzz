import 'package:flutter/material.dart';
import 'package:penzz/helpers/blood_sugar_database.dart';
import 'package:penzz/pages/save_sugar_value_screen.dart';
import 'package:penzz/helpers/storage.dart';
import 'dart:io';



class SugarValuesScreen extends StatefulWidget {
  static const String id = 'sugar_values_screen';

  @override
  _SugarValuesScreenState createState() => _SugarValuesScreenState();
}

class _SugarValuesScreenState extends State<SugarValuesScreen> {
  void initState() {
    super.initState();

    _begin();
  }

  @override
  void dispose() {
    Sugar.close();
    super.dispose();
  }

  void _begin() async {
    //await Documents.deleteDatabase();
    await Storage.loadUser();
    await Sugar.loadDatabase();

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tvoj šećer')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 30,),

              FutureBuilder<List<Sug>>(
                future: Sugar.queryAll(),

                builder: (context, snapshot) {
                  List<Sug> sugar = [];
                  if (snapshot.hasData) {
                    sugar = snapshot.data!;
                  }
                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sugar.length,
                    itemBuilder: (context, index) {
                      final sug = sugar[index];

                      return DocumentWidget(sug: sug, index: index,);
                    },
                  );
                },
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveValue,
        tooltip: 'Save sugar value',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _saveValue() async {
    Navigator.pushNamed(context, SaveSugarValueScreen.id);
  }
}

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    Key? key,
    required this.sug,
    required this.index
  }) : super(key: key);

  final Sug sug;
  final int index;

  Future<File> getDocument() async {
    File file = await Storage.getDocumentFile(sug.id, sug.sugar_value.toString());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Razina šećera " + (index+1).toString() + ":", textAlign: TextAlign.center, textScaleFactor: 1.3,),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(sug.sugar_value.toString() + ' mmol/l : uneseno ' + sug.date.toString().split(' ')[0]),
          ],
        ),
      ),
    );
  }
}
