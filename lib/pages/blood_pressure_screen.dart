import 'package:flutter/material.dart';
import 'package:penzz/helpers/blood_pressure_database.dart';
import 'package:penzz/pages/save_blood_pressure_screen.dart';
import 'package:penzz/helpers/storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:penzz/widgets/black_round_button.dart';

import 'package:syncfusion_flutter_charts/charts.dart';







class BloodPressureScreen extends StatefulWidget {
  static const String id = 'blood_pressure_screen';

  @override
  _BloodPressureScreenState createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  void initState() {
    super.initState();

    _begin();
  }

  @override
  void dispose() {
    Pressure.close();
    super.dispose();
  }

  void _begin() async {
    //await Documents.deleteDatabase();
    await Storage.loadUser();
    await Pressure.loadDatabase();

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tvoj tlak'), backgroundColor: const Color(0xff11121B),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 10,),
              FutureBuilder<List<Press>>(
                  future: Pressure.queryAll(),

                  builder: (context, snapshot) {
                    List<Press> value = [];
                    if (snapshot.hasData) {
                      value = snapshot.data!;
                    }
                    return BloodPressureChart(pressureData: value);
                  }
              ),
              const SizedBox(height: 10,),
              Text('Mjerenja:', textAlign: TextAlign.left, style: TextStyle(fontSize: 30),),
              const SizedBox(height: 5,),
              FutureBuilder<List<Press>>(
                future: Pressure.queryAll(),

                builder: (context, snapshot) {
                  List<Press> pressure = [];
                  if (snapshot.hasData) {
                    pressure = snapshot.data!;
                  }
                  //return BloodSugarChart(data:sugar);
                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pressure.length,
                    itemBuilder: (context, index) {
                      final tlak = pressure[index];
                      return DocumentWidget(pres: tlak, index: index,reload: () {setState(() {});},);

                    },
                  );
                },
              ),
            ]
        ),
      ),
      floatingActionButton: BlackRoundButton(
        onPressed: _saveValue,
        //tooltip: 'Save sugar value',
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _saveValue() async {
    await Navigator.pushNamed(context, SaveBloodPressureScreen.id);
    setState(() {
    });
  }
}

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    Key? key,
    required this.pres,
    required this.index,
    required this.reload,
  }) : super(key: key);

  final Press pres;
  final int index;
  final void Function()? reload;



  Future<File> getDocument() async {
    File file = await Storage.getDocumentFile(
        pres.id, pres.systolic_pressure_value.toString());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(
      title: Text(
        DateFormat('dd/MM/yyyy, HH:mm').format(pres.date) + ":",
        textAlign: TextAlign.left, textScaleFactor: 1.15,),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(pres.systolic_pressure_value.toString() + ' mmHg', textScaleFactor: 1.2,
              textAlign: TextAlign.left,),
            Text(pres.diastolic_pressure_value.toString() + ' mmHg', textScaleFactor: 1.2,
              textAlign: TextAlign.left,),
          ],
        ),
      ),
      trailing: IconButton(
          onPressed: () {
            _onAction(context);
          },
          iconSize: 20,
          icon: Icon(Icons.more_vert, color: Colors.grey,)
      ),
    ),
    );
  }

  void _onAction(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: new Text('Što želite napraviti s odabranom vrijednošću?'),
              ),
              ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Izbriši'),
                onTap: () async {
                  await _onSugarDelete(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _onSugarDelete(BuildContext context) async {
    bool doDelete = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Jeste li sigurni da želite odabrane podatke?'),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Natrag'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Izbriši'),
          ),
        ],
      ),
    );
    if (doDelete) {
      await Pressure.delete(pres.id);

      if (reload != null) {
        reload!();
      };
    }
  }


}
class BloodPressureChart extends StatelessWidget{
  final chartKey = GlobalKey<SfCartesianChartState>();
  List<Press> pressureData = <Press>[];
  BloodPressureChart({required this.pressureData});

  @override
  Widget build(BuildContext context){


    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text('Tvoj tlak'),
              Expanded(
                child:
                SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.hours,
                    minimum: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-1),
                    maximum: DateTime.now(),
                  ),
                  palette:<Color> [
                    Colors.teal,
                    Colors.greenAccent.withOpacity(0.98),
                  ],
                  series: <ChartSeries<Press, DateTime>>[
                    StackedLineSeries(
                        dataSource: pressureData,
                        markerSettings: MarkerSettings( isVisible : true),
                        xValueMapper: (Press values, _)=> values.date,
                        yValueMapper: (Press values, _)=> values.systolic_pressure_value,
                    ),
                    StackedLineSeries(
                        dataSource: pressureData,
                        markerSettings: MarkerSettings( isVisible: true),
                        xValueMapper: (Press values, _)=> values.date,
                        yValueMapper: (Press values, _)=> values.diastolic_pressure_value,
                    ),
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

}