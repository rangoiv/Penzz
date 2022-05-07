import'package:penzz/helpers/blood_pressure_database.dart';
import 'package:flutter/material.dart';

import 'package:penzz/helpers/constants.dart';
import 'package:penzz/widgets/black_button.dart';





class SaveBloodPressureScreen extends StatefulWidget {
  static const String id = 'save blood pressure screen';

  const SaveBloodPressureScreen({Key? key}) : super(key: key);

  @override
  _SaveBloodPressureScreenState createState() => _SaveBloodPressureScreenState();
}

class _SaveBloodPressureScreenState extends State<SaveBloodPressureScreen>{
  String s='';
  String p='';
  double input_value_sys=-1;
  double input_value_dia=-1;

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Unesi svoj šećer'), backgroundColor: const Color(0xff11121B),),
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
                  input_value_sys=double.parse(s);
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Unesi sistolički tlak'),
              autofocus: true,
              keyboardType: TextInputType.number,
            ),

            SizedBox(
              height: 24.0,
            ),

            TextField(

                onChanged: (value) async {
                  p=value;
                  input_value_dia=double.parse(p);
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Unesi dijastolički tlak'),
              autofocus: true,
              keyboardType: TextInputType.number,
            ),

            SizedBox(
              height: 24.0,
            ),
            BlackButton(
              onPressed: () async {
                try{
                  Press pressure=Press(id: await Pressure.getNewId(), systolic_pressure_value: input_value_sys,
                      diastolic_pressure_value: input_value_dia, date: DateTime.now());
                  if(pressure.systolic_pressure_value!=-1 && pressure.diastolic_pressure_value!=-1){
                    Pressure.insert(pressure);
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