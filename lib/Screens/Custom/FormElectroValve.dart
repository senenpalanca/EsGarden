import 'dart:core';

import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NFormElectroValve extends StatefulWidget {
  Plot PlotKey;
  bool firstTime = true;

  NFormElectroValve({this.PlotKey});

  @override
  _FormElectroValveState createState() => _FormElectroValveState();
}

class _FormElectroValveState extends State<NFormElectroValve> {
  //int isSelected = -1;
  bool firstTimeTab = true;
  String prevType;
  String typeSelected;
  Valve myValve;
  Valve valveOnFirebase;
  List<int> activated = [1, 0, 0, 0];
  List<int> max = [0, 0, 0, 0];
  List<int> min = [0, 0, 0, 0];
  List<TextEditingController> maxControllers = List();

  List<TextEditingController> minControllers = List();
  List<String> DropdownList = List<String>();
  var databasePlot;
  TextEditingController _valueMaxController = new TextEditingController();
  TextEditingController _valueMinController = new TextEditingController();

  @override
  void dispose() {
    _valueMaxController.dispose();
    _valueMinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    List _list = ITEMS_PLOTS[widget.PlotKey.key].toList();
    for (var i = 0; i < _list.length; i++) {
      if (_list[i] == "Vegetable" ||
          _list[i] == "ElectroValve" ||
          _list[i] == "Historic Data") {
        print(_list[i]);
      } else {
        DropdownList.add(ITEMS_PLOTS[widget.PlotKey.key][i]);
      }
    }

    //DropdownList = ITEMS_PLOTS[widget.PlotKey.key].toList();

    _initControllers();
    final _database = FirebaseDatabase.instance.reference();
    //await Future.delayed(Duration(seconds: 1));
    final databaseReference = _database.child("Gardens");
    final databaseOrchard = databaseReference.child(widget.PlotKey.parent);
    final databasePlots = databaseOrchard.child("sensorData");
    databasePlot = databasePlots.child(widget.PlotKey.key).child("Valve");

    super.initState();
  }

  void _initControllers() {
    for (var i = 0; i < 4; i++) {
      TextEditingController valueMaxController = new TextEditingController();
      TextEditingController valueMinController = new TextEditingController();
      maxControllers.add(valueMaxController);
      minControllers.add(valueMinController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databasePlot.once(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          myValve = Valve.fromSnapshot(snapshot.data);
          valveOnFirebase = myValve;
          //print(myValve.toJson());
          return Scaffold(
            appBar: AppBar(
              title: Text("ElectroValve"),
              backgroundColor: Colors.green,
              actions: <Widget>[
                PopupMenuButton<int>(
                    enabled: isAdmin,
                    itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            enabled: false,
                            value: 1,
                            child: Text(
                              "Options ",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 16.0),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            enabled: isAdmin,
                            child: FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Valve emptyValve = new Valve(
                                    sensor: myValve.sensor,
                                    min: [0, 0, 0, 0],
                                    max: [0, 0, 0, 0],
                                    active: [0, 0, 0, 0]);
                                var set =
                                    await databasePlot.set(emptyValve.toJson());
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text("All rules removed!"),
                                      );
                                    });
                              },
                              child: Text(
                                "Clear all Electrovalve rules",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 18.0),
                              ),
                            ),
                          )
                        ]),
              ],
            ),
            body: Container(
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Text("Select a sensor"),
                        ),
                        DropdownButton<String>(
                          items: DropdownList.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              typeSelected = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  _createMaxAndMin(),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _createMaxAndMin() {
    //String type = _getTypeFromReadableType(typeSelected);

    if (typeSelected != null) {
      String strWind = typeSelected == "Wind" ? "Wind Force" : "";
      String type = _getTypeFromReadableType(typeSelected);

      int myType = int.parse(CATALOG_TYPES[type]);
      myValve = valveOnFirebase;
      if (myType != myValve.sensor) {
        myValve = new Valve(sensor: myValve.sensor,
            min: [0, 0, 0, 0],
            max: [0, 0, 0, 0],
            active: [0, 0, 0, 0]);
        _setControllersText(typeSelected);
      } else {
        if (typeSelected != prevType) {
          _setControllersText(typeSelected);
          prevType = typeSelected;
        }
      }

      if (widget.firstTime) {
        _setControllersText(typeSelected);
        widget.firstTime = false;
      }

      return Card(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  typeSelected,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text(strWind),
              _createEachOne(),
              RaisedButton(
                  color: activated.contains(1) ? Colors.green : Colors.grey,
                  textColor: Colors.white,
                  child: Text("Save"),
                  onPressed: () async {
                    //print(widget._valueController.text);

                    if (_checkControllers(typeSelected)) {
                      _fillMaxAndMin(typeSelected);
                      String typetemp = _getTypeFromReadableType(typeSelected);

                      Valve newValve = Valve(active: activated,
                          max: max,
                          min: min,
                          sensor: int.parse(CATALOG_TYPES[typetemp]));
                      /* var set = await databasePlot.child(field).set({
                          "Active": isSelected == field,
                          "Sensor": type,
                          "Field": field,
                          "Max": int.parse(_valueMaxController.text),
                          "Min": int.parse(_valueMinController.text),
                        });*/
                      var set = await databasePlot.set(newValve.toJson());
                      //print("AAAAAAAAAAA");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Electrovalve updated!"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Check Max and Min!"),
                            );
                          });
                    }
                  })
            ],
          ),
        ),
      );
    }
    return Text("");
  }

  bool _checkControllers(typp) {
    String type = _getTypeFromReadableType(typp);
    int noOfValues = VALUE_RELATION[type] == null
        ? 1
        : VALUE_RELATION[type].length;


    bool error = false;
    //Comprobar que todos son enteros
    for (var i = 0; i < noOfValues; i++) {
      if (num.tryParse(maxControllers[i].text) == null) {
        error = true;
      }
    }
    for (var i = 0; i < noOfValues; i++) {
      if (num.tryParse(minControllers[i].text) == null) {
        error = true;
      }
    }

    if (!error) {
      for (var i = 0; i < noOfValues; i++) {
        if (num.tryParse(maxControllers[i].text) <
            num.tryParse(minControllers[i].text)) {
          error = true;
        }
      }
    }
    //Comprobar que el max es mayor que el min


    return !error;
  }

  void _setControllersText(String typp) {
    List<Widget> MaxAndMinTiles = [];

    String type = _getTypeFromReadableType(typp);


    int noOfValues =
    VALUE_RELATION[type] == null ? 1 : VALUE_RELATION[type].length;

    for (var i = 0; i < noOfValues; i++) {
      maxControllers[i].text = myValve.max[i].toString();
      minControllers[i].text = myValve.min[i].toString();
      activated[i] = myValve.active[i] == 1 ? 1 : 0;
    }
  }

  void _fillMaxAndMin(typp) {
    min.clear();
    max.clear();
    String type = _getTypeFromReadableType(typp);


    int noOfValues =
    VALUE_RELATION[type] == null ? 1 : VALUE_RELATION[type].length;
    for (var i = 0; i < noOfValues; i++) {
      max.add(num.tryParse(maxControllers[i].text));
      min.add(
          num.tryParse(minControllers[i].text)); //myValve.max[i].toString();
      //minControllers[i].text ;//myValve.min[i].toString();
    }
  }


  Widget _createEachOne() {
    List<Widget> MaxAndMinTiles = [];
    String type = _getTypeFromReadableType(typeSelected);
    int noOfValues =
    VALUE_RELATION[type] == null ? 1 : VALUE_RELATION[type].length;
    for (var i = 0; i < noOfValues; i++) {
      MaxAndMinTiles.add(
          _createMaxAndMinTileInside(int.parse(CATALOG_TYPES[type]), type, i));
    }
    return Column(
      children: MaxAndMinTiles,
    );
  }

  String _getTypeFromReadableType(String ReadableType) {
    print(ReadableType);
    List<String> Values = CATALOG_NAMES.values.toList();
    List<String> Keys = CATALOG_TYPES.keys.toList();

    return Keys[Values.indexOf(ReadableType)];
  }

  Widget _createMaxAndMinTileInside(int type, String readableType, int field) {
    String strPos =
    VALUE_RELATION[readableType] == null
        ? ""
        : VALUE_RELATION[readableType][field];

    return Container(
      child: Column(
        children: <Widget>[
          Text(strPos),
          Padding(
            padding: const EdgeInsets.only(
                left: 40, right: 40, bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.
              center,
              children: <Widget>[
                Switch(
                  value: activated[field] == 1,
                  onChanged: (value) {
                    print(activated);
                    print(field);
                    setState(() {
                      if (activated[field] == 1) {
                        activated[field] = 0;
                      } else {
                        activated[field] = 1;
                      }
                    });
                    print(activated);
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 70,
                    height: 30,
                    child: TextField(
                      enabled: activated[field] == 1,
                      controller: maxControllers[field],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'max',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 30,
                  child: TextField(
                    enabled: activated[field] == 1,
                    controller: minControllers[field],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'min',
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }


}

class Valve {
  List active;
  List max;
  List min;
  int sensor;
  String key;

  Valve({this.key, this.active, this.max, this.min, this.sensor});

  Valve.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        active = snapshot.value["Active"],
        sensor = snapshot.value["Sensor"],
        max = snapshot.value["Max"],
        min = snapshot.value["Min"];


  toJson() {
    return {
      "Active": active,
      "Max": max,
      "Min": min,
      "Sensor": sensor,
    };
  }
}
