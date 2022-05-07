import 'dart:io';

import 'package:flutter/material.dart';
import 'package:penzz/helpers/authorisation.dart';
import 'package:penzz/helpers/documents_database.dart';
import 'package:penzz/helpers/blood_sugar_database.dart';
import 'package:penzz/widgets/background.dart';

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
      appBar: AppBar(
          title: const Text('Postavke'),
          backgroundColor: const Color(0xff11121B),
      ),
      body: Background(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView (
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 30,),
                  Text("Mogu li se povezati sa svojim e-građanin računom?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                  SizedBox(height: 10,),
                  Text("Još uvijek nije dostupna mogućnost povezivanja aplikacije s e-građanin računom.",style: TextStyle(fontSize: 20,), textAlign: TextAlign.left,),
                  SizedBox(height: 20,),
                  Text("Hoće li mi podaci ostati spremljeni nakon što se odjavim?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                  SizedBox(height: 10,),
                  Text("Hoće, ukoliko ne pristupite računu s drugog mobilnog uređaja.",style: TextStyle(fontSize: 20,), textAlign: TextAlign.left,),
                  SizedBox(height: 20,),
                  Text("Jesu li moji podaci zaštićeni?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                  SizedBox(height: 10,),
                  Text("Jesu! Podaci su spremljeni na Vašem uređaju te su zaštićeni biosenzorom.",style: TextStyle(fontSize: 20,), textAlign: TextAlign.left,),
                  SizedBox(height: 20,),
                  Text("Hoće li mi ostati dokumenti na drugom uređaju?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                  SizedBox(height: 10,),
                  Text("Budući da se dokumenti spremaju lokalno na Vašem uređaju, još uvijek ne postoji mogućnost pristupanja dokumentima s drugog uređaja.",style: TextStyle(fontSize: 20,), textAlign: TextAlign.left,),

                  SizedBox(height: 50,),
                  BlackButton(
                    onPressed: logout,
                    text: "Logout",
                  ),
                  SizedBox(height: 60,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}