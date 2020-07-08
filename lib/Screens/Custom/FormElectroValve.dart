import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NFormElectroValve extends StatefulWidget {
  Plot PlotKey;

  NFormElectroValve({this.PlotKey});

  @override
  _FormElectroValveState createState() => _FormElectroValveState();
}

class _FormElectroValveState extends State<NFormElectroValve> {
  int isSelected = -1;

  String typeSelected;
  List<String> DropdownList = CATALOG_NAMES.values.toList();
  var databasePlot;

  @override
  void initState() {
    final _database = FirebaseDatabase.instance.reference();
    //await Future.delayed(Duration(seconds: 1));
    final databaseReference = _database.child("Gardens");
    final databaseOrchard = databaseReference.child(widget.PlotKey.parent);
    final databasePlots = databaseOrchard.child("sensorData");
    databasePlot = databasePlots.child(widget.PlotKey.key).child("Valve");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        style: TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      enabled: isAdmin,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            databasePlot.remove();
                          });
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
                          style:
                              TextStyle(color: Colors.black45, fontSize: 18.0),
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

  Widget _createMaxAndMin() {
    if (typeSelected != null && typeSelected != "Soil Temperature") {
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
              _createEachOne()
            ],
          ),
        ),
      );
    }
    return Text("");
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
    List<String> Values = CATALOG_NAMES.values.toList();
    List<String> Keys = CATALOG_TYPES.keys.toList();
    return Keys[Values.indexOf(ReadableType)];
  }

  Widget _createMaxAndMinTileInside(int type, String readableType, int field) {
    TextEditingController _valueMaxController = new TextEditingController();
    TextEditingController _valueMinController = new TextEditingController();
    String title = "";
    return Container(
      child: Column(
        children: <Widget>[
          Text(title),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Switch(
                  value: isSelected == field,
                  onChanged: (value) {
                    setState(() {
                      if (isSelected == field) {
                        isSelected = -1;
                      } else {
                        isSelected = field;
                      }
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                Container(
                  width: 70,
                  height: 30,
                  child: TextField(
                    enabled: isSelected == field,
                    controller: _valueMaxController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'max',
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 30,
                  child: TextField(
                    enabled: isSelected == field,
                    controller: _valueMinController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'min',
                    ),
                  ),
                ),
                RaisedButton(
                    color: isSelected == field ? Colors.green : Colors.grey,
                    textColor: Colors.white,
                    child: Text("Save"),
                    onPressed: () async {
                      //print(widget._valueController.text);
                      if ((num.tryParse(_valueMaxController.text) != null) &&
                          (num.tryParse(_valueMinController.text) != null) &&
                          isSelected == field) {
                        var set = await databasePlot.set({
                          "Active": isSelected == field,
                          "Sensor": type,
                          "Field": field,
                          "Max": int.parse(_valueMaxController.text),
                          "Min": int.parse(_valueMinController.text),
                        });
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
        ],
      ),
    );
  }
}
