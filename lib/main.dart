import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:penzz/pages/welcome_screen.dart';
import 'package:penzz/pages/after_login_screen.dart';
import 'package:penzz/pages/registration_screen.dart';
import 'package:penzz/pages/scan_document_screen.dart';
import 'package:penzz/pages/save_document_screen.dart';
import 'package:penzz/pages/display_documents_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'penzzTheme.dart';

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
        home: WelcomeScreen(),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          AfterLoginScreen.id: (context) => AfterLoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ScanDocumentScreen.id: (context) => ScanDocumentScreen(),
          SaveDocumentScreen.id: (context) => SaveDocumentScreen(),
          DisplayDocumentsScreen.id: (context) => DisplayDocumentsScreen(),
        }
    );
  }
}