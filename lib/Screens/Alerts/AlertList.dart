import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Alerts/AlertItem.dart';
import 'package:flutter/material.dart';

class AlertList extends StatefulWidget {
  Plot PlotKey;
  Map<String, Map> alerts = new Map();

  AlertList({this.PlotKey /*, this.alerts*/
      });

  @override
  _AlertListState createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  @override
  Widget build(BuildContext context) {
    widget.alerts = alerts;

    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts List of " + widget.PlotKey.Name),
        backgroundColor: Colors.green,
        actions: <Widget>[
          /* IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                print("clearing alerts...");
                alerts = new Map<String, Map<dynamic,dynamic>>();
              });

            },
          ),*/
        ],
      ),
      body: ListView(
        children: _getAlerts(),
      ),
    );
  }

  List<Widget> _getAlerts() {
    List<Widget> widAlerts = [Text("")];
    List AlertTypes = alerts.keys.toList();
    print(AlertTypes);
    print(alerts);
    AlertTypes.forEach((type) {
      int lengthA = 4; //Máximo
      print(lengthA);
      for (var i = 0; i < lengthA; i++) {
        Item item = alerts[type][i.toString()];
        if (item != null) {
          widAlerts.add(_createTile(type, item, i));
        }
      }
    });
    return widAlerts;
  }

  _createTile(
    String type,
    Item AlertItem,
    int position,
  ) {

    var val = AlertItem.val ?? 0;
    var exp = AlertItem.exp ?? 0;
    var cond = AlertItem.cond ?? 0;
    String tCond = cond == "Bigger" ? ">=" : "=<";
    String ReadableType = CATALOG_NAMES[CATALOG_TYPES[type]];
    String strPos =
        VALUE_RELATION[type] == null ? "" : VALUE_RELATION[type][position];
    print(strPos);
    String adder = VALUE_RELATION[type] != null ? "on $strPos" : "";
    return ListTile(
      title: Text("$ReadableType $adder"),
      subtitle: Text("Expected $tCond $exp, found $val"),
      //leading: Icon(Icons.warning),
    );
  }
}
