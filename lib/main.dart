import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:penzz/pages/blood_pressure_screen.dart';

import 'package:penzz/pages/login_screen.dart';
import 'package:penzz/pages/mass_values_screen.dart';
import 'package:penzz/pages/save_blood_pressure_screen.dart';
import 'package:penzz/pages/save_mass_screen.dart';
import 'package:penzz/pages/welcome_screen.dart';
import 'package:penzz/pages/registration_screen.dart';
import 'package:penzz/pages/scan_document_screen.dart';
import 'package:penzz/pages/save_document_screen.dart';
import 'package:penzz/pages/display_documents_screen.dart';
import 'package:penzz/pages/sugar_values_screen.dart';
import 'package:penzz/pages/save_sugar_value_screen.dart';
import 'package:penzz/pages/settings_screen.dart';

import 'package:penzz/helpers/penzzTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(initialization);

  await Firebase.initializeApp();
  //initilization of Firebase app

  // other Firebase service initialization

  runApp(Penzz());
}
Future initialization (BuildContext? context) async {
  await Future.delayed(Duration(seconds: 1));
}
class Penzz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.penzzTheme,
        home: LoginScreen(),
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ScanDocumentScreen.id: (context) => ScanDocumentScreen(),
          SaveDocumentScreen.id: (context) => SaveDocumentScreen(),
          DisplayDocumentsScreen.id: (context) => DisplayDocumentsScreen(),
          SugarValuesScreen.id: (context) => SugarValuesScreen(),
          SaveSugarValueScreen.id:(context) => SaveSugarValueScreen(),
          SettingsScreen.id:(context) => SettingsScreen(),
          MassValuesScreen.id:(context) =>MassValuesScreen(),
          SaveMassScreen.id:(context) => SaveMassScreen(),
          BloodPressureScreen.id:(context) => BloodPressureScreen(),
          SaveBloodPressureScreen.id:(context) => SaveBloodPressureScreen(),
        }
    );
  }
}