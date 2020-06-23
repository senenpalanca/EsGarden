import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Models/Vegetable.dart';
import 'package:esgarden/Screens/Graphs/MainScreen.dart';
import 'package:esgarden/UI/LineChart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formWind extends StatelessWidget {
  Vegetable vegetable;
  List<Vegetable> vegetables;
  Plot PlotKey;
  List<DataElement> data = new List<DataElement>();
  int direction;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  formWind({Key key, @required this.PlotKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HandleData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Wind"),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return formUI(context);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  HandleData() {
    data.clear();
    _database
        .reference()
        .child("Gardens")
        .child(PlotKey.parent)
        .child("sensorData")
        .child(PlotKey.key)
        .child("Data")
        .onChildAdded
        .listen(_onNewDataElement);
  }

  void _onNewDataElement(Event event) {
    DataElement n = DataElement.fromSnapshot(event.snapshot);
    data.add(n);
  }

  Widget formUI(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Card(
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Image.asset(
                            'images/Ordenadas.jpg',
                            width: 300.0,
                          ),
                          RotationTransition(
                            turns: new AlwaysStoppedAnimation(
                                _getLastValue(data, true) / 360),
                            child: Image.asset(
                              'images/Interior.png',
                              width: 300.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => formChart(
                                  PlotKey: PlotKey,
                                  color: Colors.red,
                                  type: "wind")),
                        );
                      },
                      color: Colors.deepOrange,
                      textColor: Colors.white,
                      child: Text(
                        'See Strength Graph',
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0)))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getLastValue(List data, bool first) {
    int highest = 0;
    int pos = 0;
    List<DataElement> DataElements = data;
    Map<int, List<TimeSeriesValue>> dataLists = {};
    DataElements.removeWhere((value) => value == null);
    var typeNo = int.parse(CATALOG_TYPES["wind"]);
    List value = DataElements[DataElements.length - 1].Values[typeNo];

    return value[1];
  }

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }
}
