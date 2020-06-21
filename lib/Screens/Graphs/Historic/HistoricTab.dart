import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/Screens/Graphs/SimpleGraph.dart';
import 'package:flutter/material.dart';

class HistoricTab extends StatelessWidget {
  List<DataElement> data;
  String type;
  Color color;

  HistoricTab({this.data, this.type, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: Border(
          top: BorderSide(
        color: color,
        width: 5,
      )),
      child: Container(
          child: SimpleGraph(
        color: Colors.red,
        data: this.data,
        type: type,
        showTitle: true,
      )),
    );
  }
}
