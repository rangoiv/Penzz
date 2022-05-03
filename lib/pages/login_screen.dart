import 'package:flutter/material.dart';
import 'package:penzz/helpers/constants.dart';
import 'package:penzz/helpers/local_auth.dart';
import 'package:penzz/pages/welcome_screen.dart';
import 'package:penzz/pages/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:penzz/widgets/background.dart';


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
    return Container(color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
          child: Padding(
           padding: EdgeInsets.symmetric(horizontal: 20.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: <Widget>[
               SizedBox(height: 40,),
               Text('Dobrodošli', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold'),),
               Row(children: [
                 Text('natrag u',  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold')),
                 SizedBox(width: 15,),
                 Image.asset('images/arrowCircle.png', width: 40, height: 40,)
               ],),
               SizedBox(
                 height: 30.0,
               ),
               Padding(
                 padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
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
               Material(
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
               SizedBox(
                 height: 24.0,
               ),
               Material(
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
               SizedBox(
                 height: 20.0,
               ),
               Padding(
                 padding: EdgeInsets.only(top: 110),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                   Expanded(child: InkWell(
                     onTap: () {
                       Navigator.pushNamed(context, RegistrationScreen.id);
                     },
                     child: Container(
                       decoration: BoxDecoration(color:Colors.black, borderRadius: BorderRadius.only(topLeft: Radius.circular(32), bottomLeft: Radius.circular(32))),
                       height: 45,
                       child: Center(
                         child: Text('SIGN IN',
                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold', fontSize: 15),),),),
                   )),
                     SizedBox(width: 0.5,),
                     Expanded(
                         child: InkWell(
                           onTap:  () => _onLogin(context),
                           child: Container(
                             decoration: BoxDecoration(color:Colors.black, borderRadius: BorderRadius.only(topRight: Radius.circular(32), bottomRight: Radius.circular(32))),
                             child: Center(
                               child: Text(
                                 'LOGIN',
                                 style:TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'Poppins-SemiBold', fontSize: 15) ,
                               ),
                             ),
                             height: 45 ,
                             ),
                         ))
                 ],),
               ),
               Padding(padding: EdgeInsets.only(top: 10),child: Image.asset('images/penzzTextBlack.png', height: 25,),)

             ],
           ),
            ),
        ),
      ),
    );
  }
  
  _onLogin(BuildContext context) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        print("Local auth");
        final isAuthenticated = await LocalAuthApi.authenticate();

        if (isAuthenticated) {
          print("Local authenticated success");
          Navigator.pushNamed(context, WelcomeScreen.id);
        }
      }
    }
    catch (e) {
      showAlertDialog(context);
    }
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



