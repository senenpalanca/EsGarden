/*
 * // Copyright <2020> <Universitat Politència de València>
 * // Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * // software and associated documentation files (the "Software"), to deal in the Software
 * // without restriction, including without limitation the rights to use, copy, modify, merge,
 * // publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
 * // to whom the Software is furnished to do so, subject to the following conditions:
 * //
 * //The above copyright notice and this permission notice shall be included in all copies or
 * // substantial portions of the Software.
 * // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * // EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * // OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * // AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * // THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * //
 * // This version was built by senenpalanca@gmail.com in ${DATE}
 * // Updates available in github/senenpalanca/esgarden
 * //
 * //
 */

import 'dart:async';

import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Alerts/AlertList.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AlertItem extends StatefulWidget {
  Plot PlotKey;
  String title;

  AlertItem({this.PlotKey, this.title});

  @override
  _AlertItemState createState() => _AlertItemState();
}

class _AlertItemState extends State<AlertItem> {
  bool res;
  bool showContainer = false;
  var timer;
  bool verb = false;
  final _database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    res = false;
    _getAlerts();
    setState(() {
      const oneSecond = const Duration(seconds: 2);
      timer = new Timer.periodic(oneSecond, (Timer t) => setState(() {}));
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAlerts(),
      builder: (context, snapshot) {
        if (true) {
          return Row(
            children: <Widget>[
              GestureDetector(
                child: Text(widget.title),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlertList(
                            PlotKey: widget.PlotKey,
                            //alerts: alerts,
                          )));
                },
              ),
              Icon(
                Icons.warning,
                color: res ? Colors.red : Colors.grey,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _createAlertIcon() {}

  Future<int> _getAlerts() async {
    Map<dynamic, dynamic> getMap = await _fetchData(); //get.value;
    verb ? print(getMap) : null;
    res = alerts.length == 0 ? false : true;
    alerts = new Map<String, Map<dynamic, dynamic>>();
    if (getMap != null) {
      List types = getMap.keys.toList();
      verb ? print(types.length) : null;
      for (var i = 0; i < types.length; i++) {
        var selectedType = types[i];
        verb ? print("Buscamos alertas para el tipo $selectedType") : null;

        dynamic SensorProfiles = getMap[selectedType]; //Perfiles 0,1,2,3
        //print(SensorProfiles.length);
        //Buscar el último dato existente,

        DataElement lastElement = await _getLastElement(selectedType);

        _CheckAlertsForType(SensorProfiles, selectedType, lastElement);
      }
      print(alerts);
      verb ? print("RES :> $res ALERTS :> $alerts") : null;
    }

    return 1;
  }

  Future<Map<dynamic, dynamic>> _fetchData() async {
    final databaseReference = _database.child("Alerts");
    final databaseOrchard = databaseReference.child(widget.PlotKey.parent);
    final databasePlot = databaseOrchard.child(widget.PlotKey.key);
    DataSnapshot get = await databasePlot.once();
    return get.value;
  }

  Future<DataElement> _getLastElement(selectedType) async {
    List<DataElement> elements = [];
    var data = await _database
        .reference()
        .child("Gardens")
        .child(widget.PlotKey.parent)
        .child("sensorData")
        .child(widget.PlotKey.key)
    //.child("Data").orderByChild('timestamp').once();
        .child("Data")
        .onChildAdded
        .listen((event) {
      elements.add(DataElement.fromSnapshot(event.snapshot));
    });
    await new Future.delayed(new Duration(seconds: 1));
    DataElement e = null;
    //print(elements);
    bool found = false;
    var lastInd = elements.length - 1;
    while (!found) {
      e = elements[lastInd];
      if (e != null &&
          e.Types.contains(int.parse(CATALOG_TYPES[selectedType]))) {
        found = true;
      } else {
        lastInd--;
      }
    }

    return e;
  }

  void _CheckAlertsForType(dynamic SensorProfiles, String selectedType, DataElement lastElement) {
    List keys;
    if (!(SensorProfiles is List)) {
      keys = SensorProfiles.keys.toList();
    }

    for (var profileIndex = 0;
    profileIndex < SensorProfiles.length;
    profileIndex++) {
      var AlertProfile = null;

      if (keys != null) {
        AlertProfile = SensorProfiles[keys[profileIndex]];
      } else {
        AlertProfile = SensorProfiles[profileIndex];
      }

      if (AlertProfile != null) {
        var expected = AlertProfile["Value"];
        var Condition = AlertProfile["Condition"];
        int noOfValues = VALUE_RELATION[selectedType] == null
            ? 1
            : VALUE_RELATION[selectedType].length;
        int valueToCheck = noOfValues == 1
            ? lastElement.Values[int.parse(CATALOG_TYPES[selectedType])][0]
            : lastElement.Values[int.parse(CATALOG_TYPES[selectedType])]
        [AlertProfile["Field"]];
        //print(valueToCheck);
        //print(lastElement.key);
        verb
            ? print(
            "Value to check: $valueToCheck, Condition: $Condition, Value expected: $expected")
            : null;
        switch (AlertProfile["Condition"]) {
          case "Lower":
            if (valueToCheck <= AlertProfile["Value"]) {
              var fieldNo = AlertProfile["Field"];
              if (alerts[selectedType] == null) {
                alerts[selectedType] = new Map<String, Item>();
              }
              alerts[selectedType][fieldNo.toString()] = new Item(
                  cond: "Lower", exp: AlertProfile["Value"], val: valueToCheck);

              res = true;
            }
            break;
          case "Bigger":
            if (valueToCheck >= AlertProfile["Value"]) {
              var fieldNo = AlertProfile["Field"];
              if (alerts[selectedType] == null) {
                alerts[selectedType] = new Map<String, Item>();
              }
              alerts[selectedType][fieldNo.toString()] = new Item(
                  cond: "Bigger",
                  exp: AlertProfile["Value"],
                  val: valueToCheck);
              res = true;
            }
            break;
          default:
            break;
        }
      }
    }
  }
}

class Item {
  var val;
  var exp;
  var cond;

  Item({this.cond, this.exp, this.val});
}
