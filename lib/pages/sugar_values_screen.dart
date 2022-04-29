import 'package:flutter/material.dart';
import 'package:penzz/helpers/blood_sugar_database.dart';
import 'package:penzz/pages/save_sugar_value_screen.dart';
import 'package:penzz/helpers/storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:penzz/widgets/black_round_button.dart';

import 'package:syncfusion_flutter_charts/charts.dart';







class SugarValuesScreen extends StatefulWidget {
  static const String id = 'sugar_values_screen';

  @override
  _SugarValuesScreenState createState() => _SugarValuesScreenState();
}

class _SugarValuesScreenState extends State<SugarValuesScreen> {
  void initState() {
    super.initState();

    _begin();
  }

  @override
  void dispose() {
    Sugar.close();
    super.dispose();
  }

  void _begin() async {
    //await Documents.deleteDatabase();
    await Storage.loadUser();
    await Sugar.loadDatabase();

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tvoj šećer'), backgroundColor: const Color(0xff11121B),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 10,),
              FutureBuilder<List<Sug>>(
                future: Sugar.queryAll(),

                builder: (context, snapshot) {
                  List<Sug> value = [];
                  if (snapshot.hasData) {
                    value = snapshot.data!;
                  }
                  return BloodSugarChart(sugarData: value);
                }
              ),
              const SizedBox(height: 10,),
              Text('Mjerenja:', textAlign: TextAlign.left, style: TextStyle(fontSize: 30),),
              const SizedBox(height: 5,),
              FutureBuilder<List<Sug>>(
                future: Sugar.queryAll(),

                builder: (context, snapshot) {
                  List<Sug> sugar = [];
                  if (snapshot.hasData) {
                    sugar = snapshot.data!;
                  }
                  //return BloodSugarChart(data:sugar);
                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sugar.length,
                    itemBuilder: (context, index) {
                      final sug = sugar[index];
                      return DocumentWidget(sug: sug, index: index,reload: () {setState(() {});},);

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
    await Navigator.pushNamed(context, SaveSugarValueScreen.id);
    setState(() {
    });
  }
}

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    Key? key,
    required this.sug,
    required this.index,
    required this.reload
  }) : super(key: key);

  final Sug sug;
  final int index;
  final void Function()? reload;



  Future<File> getDocument() async {
    File file = await Storage.getDocumentFile(
        sug.id, sug.sugar_value.toString());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(
      title: Text(
          DateFormat('dd/MM/yyyy, HH:mm').format(sug.date) + ":",
        textAlign: TextAlign.left, textScaleFactor: 1.15,),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(sug.sugar_value.toString() + 'mmol/l', textScaleFactor: 1.2,
              textAlign: TextAlign.left,),
          ],
        ),
      ),
      trailing: IconButton(
          onPressed: () {
            _deleteSugarValue(sug.id);
          },
          iconSize: 20,
          icon: Icon(Icons.more_vert, color: Colors.grey,)
      ),
    ),
    );
  }
}

void _deleteSugarValue(int id){
  Sugar.delete(id);
}


  


class BloodSugarChart extends StatelessWidget{
  final chartKey = GlobalKey<SfCartesianChartState>();
  List<Sug> sugarData = <Sug>[];
  BloodSugarChart({required this.sugarData});

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
                  Text('Tvoj šećer'),
                  Expanded(
                    child:
                    SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        intervalType: DateTimeIntervalType.hours,
                        minimum: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-1),
                        maximum: DateTime.now(),
                      ),
                      palette:<Color> [Colors.teal],
                      series: <ChartSeries<Sug, DateTime>>[
                      LineSeries(
                          dataSource: sugarData,
                          markerSettings: MarkerSettings( isVisible : true),
                          xValueMapper: (Sug values, _)=> values.date,
                          yValueMapper: (Sug values, _)=> values.sugar_value,
                          name: 'BloodSugar'
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



