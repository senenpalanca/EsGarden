import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Graphs/SimpleGraph.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formVisualization extends StatelessWidget {
  List<DataElement> data;
  Color color;
  String type;
  Plot PlotKey;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  formVisualization(
      {Key key,
      @required this.PlotKey,
      @required this.data,
      this.color,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Log"),
          backgroundColor: Colors.green,
        ),
        body: formUI(context));
  }

  Widget formUI(BuildContext context) {
    return Container(
        color: Colors.white70,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            SimpleGraph(color: this.color, type: this.type, data: this.data),
          ],
        ));
  }
}
