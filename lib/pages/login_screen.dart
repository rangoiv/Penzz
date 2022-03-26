import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:penzz/helpers/constants.dart';
import 'package:penzz/pages/welcome_screen.dart';
import 'package:penzz/pages/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email='';
  String password='';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.png'),fit: BoxFit.fill,
        ),),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 88,),
              Row(
                children: <Widget>[
                  Text(
                    'Dobrodošli natrag!',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              Material(
                color: Color(0XFFECF0F3),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 3,
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'E-mail'),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Material(
                color: Color(0XFFECF0F3),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 3,
                child: TextField(

                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Lozinka'),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 1, left: 100, right: 98),
                child: IconButton(constraints: BoxConstraints.expand(height: 180, width: 180),

                  icon: Image.asset('images/loginBtn.png'),
                  onPressed:  () async {
                    try {
                        final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, WelcomeScreen.id);
                      }
                    }
                    catch (e) {
                      showAlertDialog(context);
                    }},
                  iconSize: 66,
                  splashColor:  Colors.cyan,
                  visualDensity: VisualDensity.comfortable,
                )
              ),
              SizedBox(height: 10,),
              Material(

                color: Color(0XFFECF0F3),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);

                  },
                  child: Center(
                    child: Text(
                      'Stvorite račun',
                      style: TextStyle(
                        color: Color(0XFF6E7686),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans-Bold',
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Upozorenje"),
    content: Text("Prvo napravi račun ako nisi ili se ulogiraj sa svojim e-mailom!", style: TextStyle(fontFamily: 'NotoSans'),),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



