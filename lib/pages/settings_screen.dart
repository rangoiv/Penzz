import 'dart:io';

import 'package:flutter/material.dart';
import 'package:penzz/helpers/authorisation.dart';
import 'package:penzz/helpers/documents_database.dart';

import '../widgets/black_button.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Postavke')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView (
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                BlackButton(
                  onPressed: () {print("Nothing happened");},
                  text: "Izbrisi dokumente",
                ),
                BlackButton(
                  onPressed: deleteDocumentsDatabase,
                  text: "Izbrisi bazu dokumenata",
                ),
                SizedBox(height: 50,),
                BlackButton(
                  onPressed: logout,
                  text: "Logout",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteDocumentsDatabase() async {
    // TODO: izbrisati i dokumente
    await Documents.deleteDatabase();
    await Documents.loadDatabase();
  }

  void logout() async {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}