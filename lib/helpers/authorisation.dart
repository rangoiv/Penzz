import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Authorisation {
  static final _auth = FirebaseAuth.instance;
  static late User loggedInUser;

  static Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    }
    catch (e) {
      print(e);
    }
  }

  static void logout() async {
    print("Logout");
    _auth.signOut();
  }
}