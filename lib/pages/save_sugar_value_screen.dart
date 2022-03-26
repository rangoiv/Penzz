import'package:penzz/helpers/blood_sugar_database.dart';
import 'package:flutter/material.dart';
import 'package:penzz/pages/sugar_values_screen.dart';
import 'package:penzz/helpers/constants.dart';
import 'package:penzz/widgets/black_button.dart';
import 'package:penzz/widgets/black_round_button.dart';

class SaveSugarValueScreen extends StatefulWidget {
  static const String id = 'save sugar value screen';

  const SaveSugarValueScreen({Key? key}) : super(key: key);

  @override
  _SaveSugarValueScreenState createState() => _SaveSugarValueScreenState();
}

class _SaveSugarValueScreenState extends State<SaveSugarValueScreen>{
  String s='';
  int input_value=4;


  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Unesi svoj šećer')),
      body: Padding(
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
                  input_value=int.parse(s);
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Unesi razinu šećera')
            ),

            SizedBox(
              height: 24.0,
            ),
            BlackButton(
              onPressed: () async {
                try{
                  Sug sugar=Sug(id: await Sugar.getNewId(), sugar_value: input_value, date: DateTime.now());
                  if(sugar != null){
                    Sugar.insert(sugar);
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