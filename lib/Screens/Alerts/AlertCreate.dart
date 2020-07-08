import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/UI/Chip.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'file:///X:/Proyectos/flutte/ESGarden/esgarden/lib/Models/Alerts.dart';

class AlertCreate extends StatefulWidget {
  Plot PlotKey;
  String type;

  AlertCreate({this.PlotKey, this.type});

  @override
  _AlertCreateState createState() => _AlertCreateState();
}

class _AlertCreateState extends State<AlertCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Alert"),
        backgroundColor: Colors.green,
      ),
      body: Card(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.03,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.type,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              _CreateConditionTiles(),
            ],
          ),
        ),
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
    return Column(
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

class ConditionTile extends StatefulWidget {
  String type;
  bool biggerThan = false;
  int PosValue;
  Plot PlotKey;

  ConditionTile(this.PosValue, this.type, this.PlotKey);

  TextEditingController _valueController = new TextEditingController();

  @override
  _ConditionTileState createState() => _ConditionTileState();
}

class _ConditionTileState extends State<ConditionTile> {
  @override
  Widget build(BuildContext context) {
    //print(widget.biggerThan??"null");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(CATALOG_NAMES[CATALOG_TYPES[widget.type]] +
              " " +
              widget.PosValue.toString()),
          OptionChips(
            typeSeries: typeSeries,
            onSelectionChanged: _changeSeriesType,
          ),
          Container(
            width: 70,
            height: 30,
            child: TextField(
              controller: widget._valueController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'val',
              ),
            ),
          ),
          RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text("Save"),
            onPressed: () async {
              //print(widget._valueController.text);
              if (widget.PosValue != null &&
                  widget._valueController.text != null &&
                  (num.tryParse(widget._valueController.text) != null)) {
                await _createOrUpdateRule();
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Please, check the value"),
                      );
                    });
              }
            },
          )
        ],
      ),
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
    final _database = FirebaseDatabase.instance.reference();
    //await Future.delayed(Duration(seconds: 1));
    final databaseReference = _database.child("Alerts");
    final databaseOrchard = databaseReference.child(widget.PlotKey.parent);
    final databasePlot =
        databaseOrchard.child(widget.PlotKey.key).child(widget.type);
    DataSnapshot get = await databasePlot.once();
    dynamic getMap = get.value;
    print(widget.biggerThan);
    AlertModel a = new AlertModel(
      type: widget.type,
      value: (num.tryParse(widget._valueController.text) == null
          ? [0]
          : num.tryParse(widget._valueController.text)),
      condition: widget.biggerThan ? "Bigger" : "Lower",
      field: widget.PosValue,
    );

    var set =
        await databasePlot.child(widget.PosValue.toString()).set(a.toJson());
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
    //_valueController.dispose();
    super.dispose();
  }
}
