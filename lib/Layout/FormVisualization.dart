import 'package:esgarden/Structure/Plot.dart';
import 'package:esgarden/Structure/Vegetable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formVisualization extends StatelessWidget {
  Vegetable vegetable;
  List<Vegetable> vegetables;
  Plot PlotKey;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  formVisualization({Key key, @required this.PlotKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //HandleData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Log"),
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
    vegetables.clear();
    _database
        .reference()
        .child('Gardens')
        .child(PlotKey.parent)
        .child('plot')
        .child(PlotKey.key)
        .onChildAdded
        .listen(_onNewVegetable);
  }

  void _onNewVegetable(Event event) {
    Vegetable n = Vegetable.fromSnapshot(event.snapshot);
    vegetables.add(n);
  }

  Widget formUI() {
    return Container(
      color: Colors.white70,
      child: ListView(),
    );
  }

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "WaitFinish");
  }
}
