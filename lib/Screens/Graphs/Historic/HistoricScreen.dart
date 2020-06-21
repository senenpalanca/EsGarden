import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Graphs/Historic/HistoricTab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoricScreen extends StatelessWidget {
  List<DataElement> data = new List<DataElement>();
  Plot PlotKey;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<String> typesToShow = ["soiltemperature", "soilhumidity"];

  HistoricScreen({Key key, @required this.PlotKey}) : super(key: key);

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }

  @override
  Widget build(BuildContext context) {
    HandleData();
    return Scaffold(
        appBar: AppBar(
          title: Text(PlotKey.Vegetable),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return formUI();
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

  Widget formUI() {
    return Container(
      color: Colors.white70,
      child: ListView(
        padding: EdgeInsets.all(8),
        children: typesToShow.map<Widget>((type) => _buildItem(type)).toList(),
      ),
    );
  }

  _buildItem(String tp) {
    return HistoricTab(
      data: this.data,
      type: tp,
      color: Colors.green,
    );
  }
}
