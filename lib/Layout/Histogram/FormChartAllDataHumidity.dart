import 'dart:ui';

import 'package:esgarden/Structure/DataElement.dart';
import 'package:esgarden/Structure/Plot.dart';
import 'package:esgarden/UI/LineChart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Library/Globals.dart';

class formChartAllData extends StatelessWidget {
  List<DataElement> data = new List<DataElement>();
  Plot PlotKey;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  formChartAllData({Key key, @required this.PlotKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HandleData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Historical Data"),
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
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
              height: 100,
              //  width: 800,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Card(
                    elevation: 3.0,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, bottom: 16, top: 16),
                      child: Center(
                          child: Text(
                        "Temperature",
                        style: TextStyle(fontSize: 20.0),
                      )),
                    )),
              )),
          Container(
              height: 350,
              //  width: 800,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Card(
                    elevation: 3.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 800,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 16, bottom: 16),
                            child: LineChart.createData(
                                Colors.red, data, "soiltemperature", 100),
                          ),
                        ),
                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }

  Widget createGraph(BuildContext context, List<DataElement> data, int day,
      Color color, String type) {
    String days;
    switch (day) {
      case 0:
        days = "Today";
        break;
      case 1:
        days = "Yesterday";
        break;
      default:
        days = day.toString() + " days ago";
        break;
    }

    int maxValue = 0;
    int minValue = 0;

    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        child: Card(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      CATALOG_NAMES[CATALOG_TYPES[type]] +
                          " (" +
                          MEASURING_UNITS[type] +
                          " ) " +
                          days,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 30, right: 30, bottom: 15),
                child: Container(
                  width: 300,
                  child: Material(
                    color: color,
                    elevation: 4.0,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "MAX",
                                style: TextStyle(
                                    fontSize: 26, color: Colors.white),
                              ),
                              Text(
                                maxValue.toString() + MEASURING_UNITS[type],
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "MIN",
                                style: TextStyle(
                                    fontSize: 26, color: Colors.white),
                              ),
                              Text(
                                minValue.toString() + MEASURING_UNITS[type],
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 50),
                child: Container(
                  height: 320,
                  width: 290,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                  ),
                ),
              ),

              //_createNotificationTab(notifications),
            ],
          ),
        ),
      ),
    ));
  }
}
