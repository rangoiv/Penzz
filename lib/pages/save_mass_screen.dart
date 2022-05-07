import'package:penzz/helpers/mass_database.dart';
import 'package:flutter/material.dart';

import 'package:penzz/helpers/constants.dart';
import 'package:penzz/widgets/black_button.dart';





class SaveMassScreen extends StatefulWidget {
  static const String id = 'save mass screen';

  const SaveMassScreen({Key? key}) : super(key: key);

  @override
  _SaveMassScreenState createState() => _SaveMassScreenState();
}

class _SaveMassScreenState extends State<SaveMassScreen>{
  String s='';
  double input_value=-1;


  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Unesi svoju masu'), backgroundColor: const Color(0xff11121B),),
      body:Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            SizedBox(
              height: 48.0,
            ),
            TextField(

                onChanged: (value) async {
                  s=value;
                  input_value=double.parse(s);
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Unesi svoju masu'),
              autofocus: true,
              keyboardType: TextInputType.number,
            ),

            SizedBox(
              height: 24.0,
            ),
            BlackButton(
              onPressed: () async {
                try{
                  mass masa=mass(id: await Mass.getNewId(), mass_value: input_value, date: DateTime.now());
                  if(masa.mass_value!=-1){
                    Mass.insert(masa);
                    Navigator.pop(context);
                  }
                }
                catch(e){
                  print(e);
                }
              },
              text: "Spremi",
            ),
          ],
        ),
      ),
    );
  }

}