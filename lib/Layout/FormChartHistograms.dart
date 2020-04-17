import 'dart:ui';

import 'package:esgarden/Layout/Histogram/FormChartAllData.dart';
import 'package:esgarden/Structure/DataElement.dart';
import 'package:esgarden/Structure/Plot.dart';
import 'package:esgarden/UI/LineChart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formChartHistograms extends StatelessWidget {
  List<DataElement> data = new List<DataElement>();
  Plot PlotKey;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  formChartHistograms({Key key, @required this.PlotKey}) : super(key: key);

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
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    //formChartHistograms
                    MaterialPageRoute(
                        builder: (context) => formChartAllData(
                              PlotKey: PlotKey,
                              color: Colors.red,
                              dataType: 'soiltemperature',
                            )));
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.85,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Card(
                        shape: Border(
                            top: BorderSide(
                          color: Colors.red,
                          width: 5,
                        )),
                        elevation: 3.0,
                        child: Column(
                          //scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Temperature",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 210,
                              width: MediaQuery.of(context).size.width,
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
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  //formChartHistograms
                  MaterialPageRoute(
                      builder: (context) => formChartAllData(
                            PlotKey: PlotKey,
                            color: Colors.blue,
                            dataType: 'soilhumidity',
                          )));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.85,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Card(
                      shape: Border(
                          top: BorderSide(
                        color: Colors.blueAccent,
                        width: 5,
                      )),
                      elevation: 3.0,
                      child: Column(
                        //scrollDirection: Axis.vertical,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Humidity",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 210,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, bottom: 16),
                              child: LineChart.createData(
                                  Colors.blue, data, "soilhumidity", 100),
                            ),
                          ),
                        ],
                      )),
                )),
          ),
        ],
      ),
    );
  }

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }
}
