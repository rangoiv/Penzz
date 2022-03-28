import 'package:flutter/material.dart';

import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/storage.dart';

import 'package:penzz/pages/settings_screen.dart';
import 'package:penzz/pages/sugar_values_screen.dart';
import 'package:penzz/pages/scan_document_screen.dart';
import 'package:penzz/pages/display_documents_screen.dart';
import 'package:penzz/pages/sugar_values_screen.dart';

import 'package:penzz/widgets/black_button.dart';
import 'package:penzz/helpers/authorisation.dart';
import 'package:penzz/widgets/green_circle.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String helloMessage = 'Pozdrav!';

  @override
  void initState() {
    super.initState();

    // TODO: dodati loading screen dok se ovo ucitava
    _loadAll();
  }

  @override
  void dispose() {
    // Dispose of all databases
    Documents.close();

    // Logout the user
    Authorisation.logout();

    super.dispose();
  }

  void _loadAll() async {
    // TODO: napraviti ovo u zasebnu funkciju
    // Load storage system
    await Authorisation.getCurrentUser();
    await Storage.loadUser();
    // Load all databases
    await Documents.loadDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context,SettingsScreen.id);
            },
          ),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Positioned(
            child: GreenCircle(radius: 300),
            top: 150,
            right: -130,
          ),
          Positioned(
            child: GreenCircle(radius: 200),
            top: 260,
            right: 70,
          ),
          Positioned(
            child: GreenCircle(radius: 130),
            top: 380,
            right: 30,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 110.0),
                  Row(
                    children: <Widget> [
                      Text(
                        helloMessage,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 190.0),
                  BlackButton(
                    onPressed: ()  {
                      Navigator.pushNamed(context, DisplayDocumentsScreen.id);

                    },
                    text: "Dokumenti",
                  ),
                  BlackButton(
                    onPressed: ()  {
                      Navigator.pushNamed(context, SugarValuesScreen.id);
                    },
                    text: "Tvoji podatci",
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }
}

