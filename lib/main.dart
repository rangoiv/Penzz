import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'pages/takingPicturePage.dart';

import 'package:penzz/pages/welcome_screen.dart';
import 'package:penzz/pages/after_login_screen.dart';
import 'package:penzz/pages/registration_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/*Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: //TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
       // camera: firstCamera,
       WelcomeScreen()
      ),
    ),
  );
}
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  //initilization of Firebase app

  // other Firebase service initialization

  runApp(FlashChat());
}

//void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          AfterLoginScreen.id: (context) => AfterLoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),

        }
    );
  }
}