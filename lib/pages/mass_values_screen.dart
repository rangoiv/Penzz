import 'package:flutter/material.dart';
import 'package:penzz/helpers/mass_database.dart';
import 'package:penzz/pages/save_mass_screen.dart';
import 'package:penzz/helpers/storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:penzz/widgets/black_round_button.dart';

import 'package:syncfusion_flutter_charts/charts.dart';







class MassValuesScreen extends StatefulWidget {
  static const String id = 'mass_values_screen';

  @override
  _MassValuesScreenState createState() => _MassValuesScreenState();
}

class _MassValuesScreenState extends State<MassValuesScreen> {
  void initState() {
    super.initState();

    _begin();
  }

  @override
  void dispose() {
    Mass.close();
    super.dispose();
  }

  void _begin() async {
    //await Documents.deleteDatabase();
    await Storage.loadUser();
    await Mass.loadDatabase();

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tvoja masa'), backgroundColor: const Color(0xff11121B),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 10,),
              FutureBuilder<List<mass>>(
                  future: Mass.queryAll(),

                  builder: (context, snapshot) {
                    List<mass> value = [];
                    if (snapshot.hasData) {
                      value = snapshot.data!;
                    }
                    return MassChart(massData: value);
                  }
              ),
              const SizedBox(height: 10,),
              Text('Mjerenja:', textAlign: TextAlign.left, style: TextStyle(fontSize: 30),),
              const SizedBox(height: 5,),
              FutureBuilder<List<mass>>(
                future: Mass.queryAll(),

                builder: (context, snapshot) {
                  List<mass> masa = [];
                  if (snapshot.hasData) {
                    masa = snapshot.data!;
                  }
                  //return BloodSugarChart(data:sugar);
                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: masa.length,
                    itemBuilder: (context, index) {
                      final val = masa[index];
                      return DocumentWidget(val: val, index: index,reload: () {setState(() {});},);

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
    await Navigator.pushNamed(context, SaveMassScreen.id);
    setState(() {
    });
  }
}

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    Key? key,
    required this.val,
    required this.index,
    required this.reload,
  }) : super(key: key);

  final mass val;
  final int index;
  final void Function()? reload;



  Future<File> getDocument() async {
    File file = await Storage.getDocumentFile(
        val.id, val.mass_value.toString());
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(
      title: Text(
        DateFormat('dd/MM/yyyy, HH:mm').format(val.date) + ":",
        textAlign: TextAlign.left, textScaleFactor: 1.15,),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(val.mass_value.toString() + 'kg', textScaleFactor: 1.2,
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
                  await _onMassDelete(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _onMassDelete(BuildContext context) async {
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
      await Mass.delete(val.id);

      if (reload != null) {
        reload!();
      };
    }
  }


}
class MassChart extends StatelessWidget{
  final chartKey = GlobalKey<SfCartesianChartState>();
  List<mass> massData = <mass>[];
  MassChart({required this.massData});

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
              Text('Tvoja masa'),
              Expanded(
                child:
                SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.hours,
                    minimum: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-1),
                    maximum: DateTime.now(),
                  ),
                  palette:<Color> [Colors.teal],
                  series: <ChartSeries<mass, DateTime>>[
                    LineSeries(
                        dataSource: massData,
                        markerSettings: MarkerSettings( isVisible : true),
                        xValueMapper: (mass values, _)=> values.date,
                        yValueMapper: (mass values, _)=> values.mass_value,
                        name: 'Mass'
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
