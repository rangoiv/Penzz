import 'package:flutter/material.dart';
import 'package:penzz/constants.dart';
import 'package:penzz/pages/after_login_screen.dart';
import 'package:penzz/pages/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  String email='';
  String password='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[

                Text(
                  'Dobrodošli natrag!',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 48.0,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email')
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password')
            ),
            SizedBox(
              height: 24.0,
            ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () async {
              try {
                final user = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (user != null) {
                  Navigator.pushNamed(context, AfterLoginScreen.id);
                }
              }
              catch(e){
                print(e);
              }

            },
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);

            },

            minWidth: 200.0,
            height: 42.0,
            child: Text(
              'Stvorite račun',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
          ],
        ),
      ),
    );
  }
}

