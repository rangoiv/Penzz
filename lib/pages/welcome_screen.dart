import 'package:flutter/material.dart';

import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/storage.dart';

import 'package:penzz/pages/settings_screen.dart';
import 'package:penzz/pages/sugar_values_screen.dart';
import 'package:penzz/pages/display_documents_screen.dart';
import 'package:penzz/widgets/background.dart';

import 'package:penzz/widgets/black_button.dart';
import 'package:penzz/helpers/authorisation.dart';
  
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
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
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
        body: Background(
          inverted: true,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20,),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(helloMessage, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold'), textAlign: TextAlign.right,),
                    ],
                  ),

                  const SizedBox(height: 250.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Odaberi radnju!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold'), textAlign: TextAlign.right,),
                    ],
                  ),
                  Divider(color: Colors.black, thickness: 0.5, height: 5,),
                  BlackButton(
                    onPressed: ()  {
                      Navigator.pushNamed(context, DisplayDocumentsScreen.id);

                    },
                    text: "Dokumenti",
                    icon: new Icon(Icons.insert_drive_file_rounded, color: Colors.white,),
                  ),
                  BlackButton(
                    onPressed: ()  {
                      _onYourData(context);
                    },
                    text: "Tvoji podatci",
                    icon: new Icon(Icons.keyboard_arrow_down, color: Colors.white,),
                  ),
                  Divider(color: Colors.black, thickness: 0.5, height: 5,),
                  Padding(padding: EdgeInsets.only(top: 25),child: Image.asset('images/penzzTextBlack.png', height: 25,),)

                ],
            ),
          ),
        ),
      ),
    );
  }

  void _onYourData(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: new Text('Tvoji podaci:'),
              ),
              ListTile(
                leading: new Icon(Icons.bloodtype),
                title: new Text('Tvoj krvni tlak'),
                onTap: () async {
                  Navigator.pop(context);

                },
              ),
              ListTile(
                leading: new Icon(Icons.bloodtype),
                title: new Text('Tvoj šećer'),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SugarValuesScreen.id);
                },
              ),
              ListTile(
                leading: new Icon(Icons.accessibility_sharp),
                title: new Text('Tvoj masa'),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    print('Backbutton pressed (device or appbar button), do whatever you want.');

    //trigger leaving and use own data
    //Navigator.pop(context, false);
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Jeste li sigurni da želite izaći?'),

        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ne'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Da');
            },
            child: const Text('Da'),
          ),
        ],
      ),
    );

    if (result != null) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
}

