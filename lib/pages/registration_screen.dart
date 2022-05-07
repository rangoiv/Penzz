import 'package:flutter/material.dart';
import 'package:penzz/helpers/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:penzz/pages/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:penzz/widgets/background.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email='';
  String password='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 15, right: 12, top: 40),
              margin: EdgeInsets.only(bottom: 30),
              child: Text('Briga o tvom zdravlju počinje ovdje', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold')),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
              child: Container(
                child: Center(child: Image.asset('images/penzzTextWhite.png', width: 220,),),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.withOpacity(0.98),
                      Colors.greenAccent.withOpacity(0.98),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(10, 10),
                        blurRadius: 20,
                        color: Colors.teal.withOpacity(0.2)),
                  ],
                ),
              ),
            ),


            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 1,

                child: TextField(
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'E-mail', hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,  fontFamily: 'Poppins-SemiBold')),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 1,
                child: TextField(
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),

                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Lozinka',hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,  fontFamily: 'Poppins-SemiBold'),),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 110),
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 1.0,
                child: MaterialButton(
                  onPressed:() async {
                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, WelcomeScreen.id);
                      }
                    }
                    catch (e) {
                      print(e);
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Stvorite račun',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,  fontFamily: 'Poppins-SemiBold'),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10),child: Image.asset('images/penzzTextBlack.png', height: 25,),)

          ],
        ),
      ),
    );
  }
}