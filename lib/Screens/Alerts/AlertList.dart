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
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Alerts/AlertItem.dart';
import 'package:flutter/material.dart';

class AlertList extends StatefulWidget {
  Plot PlotKey;

  AlertList({this.PlotKey /*, this.alerts*/
  });

  @override
  _AlertListState createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  List<Widget> items = new List();

  @override
  void dispose() {
    items = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //   widget.alerts = alerts;
    items = _getAlerts();
    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts List of " + widget.PlotKey.Name),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                print(alerts);
                // widget.alerts = alerts;
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: items,
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

  _createTile(String type,
      Item AlertItem,
      int position,) {
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

class AlertListView extends StatelessWidget {
  Plot PlotKey;

  AlertListView({this.PlotKey});

  @override
  Widget build(BuildContext context) {
    return Container();
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
      leading: Icon(Icons.warning),
      title: Text("$ReadableType $adder"),
      subtitle: Text("Expected $tCond $exp, found $val"),
      //leading: Icon(Icons.warning),
    );
  }
}
