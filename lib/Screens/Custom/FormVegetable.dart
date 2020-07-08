import 'dart:ui';

import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Models/Vegetable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formVegetable extends StatelessWidget {
  Vegetable vegetable;
  List<Vegetable> vegetables;
  Plot PlotKey;
  Color color = Colors.green;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  formVegetable({Key key, @required this.PlotKey}) : super(key: key);

  Future<String> getDataFromFuture() async {
    return new Future.delayed(Duration(milliseconds: 2000), () => "WaitFinish");
  }

  @override
  Widget build(BuildContext context) {
    HandleData();
    return Scaffold(
        appBar: AppBar(
          title: Text(PlotKey.Vegetable),
          backgroundColor: color,
        ),
        body: FutureBuilder(
          future: getDataFromFuture(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              findMyVegetable();
              return formUI(context);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  findMyVegetable() {
    vegetable = vegetables.singleWhere((veg) {
      return veg.key == PlotKey.vegetableIndex;
    });
    print(vegetable);
    //print(veg);
  }

  HandleData() {
    vegetables = new List<Vegetable>();
    vegetables.clear();
    _database
        .reference()
        .child('Vegetables')
        .onChildAdded
        .listen(_onNewVegetable);
  }

  void _onNewVegetable(Event event) {
    Vegetable n = Vegetable.fromSnapshot(event.snapshot);
    vegetables.add(n);
  }

  Widget formUI(BuildContext context) {
    int height = 610;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      height = 295;
    }

    return Container(
      color: Colors.white70,
      child: ListView(
        children: <Widget>[
          _createPhoto(context),
          //_createDescr(),
          _createTemp(),
          _createDescr()
        ],
      ),
    );
  }

  _createPhoto(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
              child: Image(
            image: NetworkImage(vegetable.imgBig), //1200x900
          )),
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.black12, Colors.black12, Colors.black],
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10, right: 10),
              child: Text(
                vegetable.Description,
                style: TextStyle(
                  fontSize: 23,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 1
                    ..color = Colors.white,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  _createDescr() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Container(
            width: 330,
            child: Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                  child: Text(
                    vegetable.name,
                    style: TextStyle(
                      fontSize: 25,
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..strokeWidth = 1
                        ..color = Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 20.0),
                  child: Text(
                    vegetable.BigDescription.replaceAll(". ", ".\n"),
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ))),
      ),
    );
  }

  _createTemp() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(),
        child: new Container(
            child: Material(
                color: Colors.white,
                elevation: 6.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, bottom: 20, top: 20),
                          child: Icon(
                            Icons.blur_circular,
                            size: 55,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  vegetable.name,
                                  style: TextStyle(
                                    fontSize: 30,
                                    foreground: Paint()
                                      ..style = PaintingStyle.fill
                                      ..color = Colors.green
                                      ..strokeWidth = 2
                                      ..color = Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "from " + vegetable.continent,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: <Widget>[
                          /*
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "h ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  Text(
                                    vegetable.hsupMin.toString() +
                                        "% - " +
                                        vegetable.hsupMax.toString() +
                                        "%",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),*/
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "t ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  vegetable.tmpMin.toString() +
                                      "º C to " +
                                      vegetable.tmpMax.toString() +
                                      "º C",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
      ),
    );
  }



}
