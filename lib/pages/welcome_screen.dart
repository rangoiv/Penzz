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
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.black, size: 35),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black,),
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
            child: GreenCircle(radius: 280),
            top: 20,
            left: -100,
          ),
          Positioned(
            child: GreenCircle(radius: 130),
            top: 150,
            right: 160,
          ),
          Positioned(
            child: GreenCircle(radius: 180),
            top: 170,
            left: -30,
          ),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      SizedBox(width: 180,),
                      Text(helloMessage, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold'), textAlign: TextAlign.right,),
                    ],
                  ),

                  const SizedBox(height: 250.0),
                  Row(
                    children: [
                      SizedBox(width: 140,),
                      Text('Odaberi radnju!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold'), textAlign: TextAlign.right,),
                    ],
                  ),
                  Divider(color: Colors.black, thickness: 0.5, height: 5,),
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
                  Divider(color: Colors.black, thickness: 0.5, height: 5,),
                  Padding(padding: EdgeInsets.only(top: 25),child: Image.asset('images/penzzTextBlack.png', height: 25,),)

                ],
            ),
          ),
        ],
      ),
    );
  }
}

