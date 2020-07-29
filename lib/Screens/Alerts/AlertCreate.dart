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

import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/Alerts.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AlertCreate extends StatefulWidget {
  Plot PlotKey;
  String type;

  AlertCreate({this.PlotKey, this.type});

  @override
  _AlertCreateState createState() => _AlertCreateState();
}

class _AlertCreateState extends State<AlertCreate> {
  List<TextEditingController> valueControllers = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _initController() {
    for (var i = 0; i < 4; i++) {
      TextEditingController valueController = new TextEditingController();
      valueControllers.add(valueController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Alert"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.type,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              child: _CreateConditionTiles()),
        ],
      ),
    );
  }

  Widget _CreateConditionTiles() {
    List<Widget> ConditionTiles = [];
    String type = _getTypeFromReadableType(widget.type);
    int noOfValues =
    VALUE_RELATION[type] == null ? 1 : VALUE_RELATION[type].length;
    for (var i = 0; i < noOfValues; i++) {
      ConditionTiles.add(new ConditionTile(i, type, widget.PlotKey));
    }
    return ListView(
      children: ConditionTiles,
    );
  }

  String _getTypeFromReadableType(String ReadableType) {
    List<String> Values = CATALOG_NAMES.values.toList();
    List<String> Keys = CATALOG_TYPES.keys.toList();
    print(Values);
    return Keys[Values.indexOf(ReadableType)];
  }
}

const List<String> typeSeries = ["<=", ">="];
enum CondType { bigger, lower }

class ConditionTile extends StatefulWidget {
  String type;
  bool biggerThan = true;
  int PosValue;
  Plot PlotKey;
  bool FirstTime = true;

  ConditionTile(this.PosValue, this.type, this.PlotKey);

  TextEditingController _valueController = new TextEditingController();

  @override
  _ConditionTileState createState() => _ConditionTileState();
}

class _ConditionTileState extends State<ConditionTile> {
  AlertModel myAlert;
  var databasePlot;
  CondType _condType = CondType.bigger;
  bool SwitchValue = false;

  @override
  void initState() {
    final _database = FirebaseDatabase.instance.reference();
    //await Future.delayed(Duration(seconds: 1));
    final databaseReference = _database.child("Alerts");
    final databaseOrchard = databaseReference.child(widget.PlotKey.parent);
    databasePlot = databaseOrchard
        .child(widget.PlotKey.key)
        .child(widget.type)
        .child(widget.PosValue.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String strPos =
    VALUE_RELATION[widget.type] == null ? "" : VALUE_RELATION[widget
        .type][widget.PosValue];

    //print(widget.biggerThan??"null");
    return FutureBuilder(
      future: databasePlot.once(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          try {
            myAlert = AlertModel.fromSnapshot(snapshot.data);
            if (widget.FirstTime) {
              widget.biggerThan = myAlert.condition == "Bigger" ? true : false;
              _condType = myAlert.condition == "Bigger"
                  ? CondType.bigger
                  : CondType.lower;

              widget._valueController.text = myAlert.value.toString();

              widget.FirstTime = false;
              SwitchValue = true;
            }
          } catch (Exception) {
            print("no alerts for this tile");
            myAlert = null;
          }
          //widget._valueController.text = myAlert.value.toString()?"";
          //print(snapshot.data.value);
          //return Text(widget.type);
          return Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[

                      Switch(
                        value: SwitchValue,
                        onChanged: (value) async {
                          setState(() {
                            if (SwitchValue) {
                              SwitchValue = false;
                              var set = databasePlot.set({});
                            } else {
                              SwitchValue = true;
                            }
                          });
                        },
                      ),
                      Text(CATALOG_NAMES[CATALOG_TYPES[widget.type]] +
                          " - " +
                          strPos),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      /*OptionChips(
                          typeSeries: typeSeries,
                          onSelectionChanged: _changeSeriesType,

                        ),*/
                      Radio(
                        value: CondType.bigger,
                        groupValue: _condType,
                        onChanged: (value) {
                          setState(() {
                            _condType = value;
                          });
                        },
                      ),
                      Text(">="),
                      Radio(
                        value: CondType.lower,
                        groupValue: _condType,
                        onChanged: (value) {
                          setState(() {
                            _condType = value;
                          });
                        },
                      ),
                      Text("<="),
                      Container(
                        width: 70,
                        height: 30,
                        child: TextField(
                          controller: widget._valueController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'value',
                          ),
                        ),
                      ),
                      /*
                        Text("<=", style: TextStyle(fontSize: !widget.biggerThan ? 16 : 13, color: !widget.biggerThan ? Colors.black : Colors.grey),),
                        Switch(value: widget.biggerThan,onChanged: (value) {
                          setState(() {
                            if (widget.biggerThan) {
                              widget.biggerThan = false;
                            } else {
                              widget.biggerThan =true ;
                            }
                          });
                        },),
                        Text(">=", style: TextStyle(fontSize: widget.biggerThan ? 16 : 13, color: widget.biggerThan ? Colors.black : Colors.grey),),
                          */


                    ],
                  ),
                  RaisedButton(
                    color: SwitchValue ? Colors.green : Colors.grey,
                    textColor: Colors.white,
                    child: Text("Save"),
                    onPressed: () async {
                      //print(widget._valueController.text);
                      if (SwitchValue && widget.PosValue != null &&
                          widget._valueController.text != null &&
                          (num.tryParse(widget._valueController.text) !=
                              null)) {
                        await _createOrUpdateRule();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("Please, check the Alert"),
                              );
                            });
                      }
                    },
                  )
                ],
              ),
            ),
          );
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  _changeSeriesType(String chipText) {
    setState(() {
      if (chipText == "<=") {
        widget.biggerThan = false;
      } else {
        widget.biggerThan = true;
      }
    });
  }

  Future<int> _createOrUpdateRule() async {
    DataSnapshot get = await databasePlot.once();
    dynamic getMap = get.value;

    AlertModel a = new AlertModel(
      type: widget.type,
      value: (num.tryParse(widget._valueController.text) == null
          ? [0]
          : num.tryParse(widget._valueController.text)),
      condition: _condType == CondType.bigger ? "Bigger" : "Lower",
      field: widget.PosValue,
    );

    var set = await databasePlot.set(a.toJson());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Alert created!"),
          );
        });
  }

  @override
  void dispose() {
    widget._valueController.dispose();
    super.dispose();
  }
}
