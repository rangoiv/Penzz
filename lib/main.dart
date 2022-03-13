import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'pages/scan_document_screen.dart';

import 'package:penzz/pages/welcome_screen.dart';
import 'package:penzz/pages/after_login_screen.dart';
import 'package:penzz/pages/registration_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'penzzTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  //initilization of Firebase app

  // other Firebase service initialization

  runApp(Penzz());
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
          DisplayDocumentScreen.id: (context) => DisplayDocumentScreen(),
        }
    );
  }
}