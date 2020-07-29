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

import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Alerts/AlertCreate.dart';
import 'package:esgarden/Screens/Graphs/Days/DayTab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Library/Globals.dart';

class formChart extends StatefulWidget {
  Plot PlotKey;
  Color color;
  String type;

  formChart({Key key, @required this.PlotKey, this.color, this.type})
      : super(key: key);

  //private vars
  bool firstTime = true;
  int lastTabId = 1000;

  @override
  formChartState createState() {
    return formChartState();
  }
}

class formChartState extends State<formChart> {
  List<DataElement> data = new List<DataElement>();

  List<Widget> tabs = [];
  PageController ctrl; //= new PageController(initialPage: widget.lastTabId);
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  HandleData() {
    data.clear();
    _database
        .reference()
        .child("Gardens")
        .child(widget.PlotKey.parent)
        .child("sensorData")
        .child(widget.PlotKey.key)
        .child("Data")
        .onChildAdded
        .listen(_onNewDataElement);
  }

  void _onNewDataElement(Event event) {
    DataElement n = DataElement.fromSnapshot(event.snapshot);
    data.add(n);
  }

  Future<String> waitToLastPage() async {
    return new Future.delayed(Duration(milliseconds: 150), () => "1");
  }

  @override
  Widget build(BuildContext context) {
    HandleData();
    // print("************* DEBUG **************");
    // print(" CATALOG_TYPE >  " + CATALOG_TYPES[widget.type]);
    // print(" CATALOG_NAME >  " + CATALOG_NAMES[CATALOG_TYPES[widget.type]]);

    return Scaffold(
      appBar: AppBar(
        title: Text(CATALOG_NAMES[CATALOG_TYPES[widget.type]] +
            " of " +
            widget.PlotKey.Name),
        backgroundColor: widget.color,
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
                      print("pressed");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlertCreate(
                                PlotKey: widget.PlotKey,
                                type: CATALOG_NAMES[
                                CATALOG_TYPES[widget.type]],
                              )));
                    },
                    child: Text(
                      "Create Alert",
                      style:
                      TextStyle(color: Colors.black45, fontSize: 18.0),
                    ),
                  ),
                ),
              ]),
        ],
      ),
      body: FormUI(),
    );
  }

  Widget FormUI() {
    _prepareTabs();
    if (widget.firstTime) {
      widget.firstTime = false;
      return FutureBuilder(
          future: waitToLastPage(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              print(data);
              List<Widget> buf = _createTabs(context);
              tabs = buf;

              widget.lastTabId = tabs.length - 2;

              return PageView(
                scrollDirection: Axis.horizontal,
                controller: ctrl,
                children: tabs,
              );
              ;
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: ctrl,
      children: tabs,
    );
  }

  String _getDate(DateTime now) {
    String day;
    String month = months[now.month - 1];
    String year = now.year.toString();
    if (now.day.toInt() < 10) {
      day = '0' + now.day.toString();
    } else
      day = now.day.toString();
    return (day + month + year);
  }

  void _prepareTabs() {
    ctrl = PageController(initialPage: widget.lastTabId);
    ctrl.addListener(() {
      widget.lastTabId = ctrl.page.toInt();
    });
  }

  List<Widget> _createTabs(context) {
    List<DataElement> DataElements = this.data.map((DataElement item) {
      int p = int.parse(CATALOG_TYPES[widget.type.toLowerCase()]);
      if (item.Types.contains(p)) {
        return item;
      }
    }).toList();
    DataElements.removeWhere((value) => value == null);
    Map<dynamic, dynamic> dias = new Map();
    if (DataElements.length > 0) {
      String firstDate = _getDate(DataElements[0].timestamp);
      //Inicializar días
      dias = _createDias(
          DataElements[0].timestamp.add(new Duration(hours: 1)),
          DataElements[DataElements.length - 1]
              .timestamp
              .add(new Duration(hours: 1)));

      for (var index = 0; index < DataElements.length; index++) {
        String date =
        _getDate(DataElements[index].timestamp.add(new Duration(hours: 1)));
        if (date == firstDate) {
          dias[date].add(DataElements[index]);
        } else {
          //dias[date] = new List<DataElement>();
          dias[date].add(DataElements[index]);
          firstDate = date;
        }
      }
    }

    ////END Prepare Data

    List<Widget> fin = [];
    for (int i = 0; i < dias.length; i++) {
      if (dias[dias.keys.toList()[i]].toList().length > 0) {
        print("data ${dias[dias.keys.toList()[i]]}");
        fin.add(new DayTab(
          data: dias[dias.keys.toList()[i]],
          day: dias.length - (i + 1),
          color: widget.color,
          type: widget.type,
          PlotKey: widget.PlotKey,
          dayText: dias.keys.toList()[i],
        ));
      }
    }
    return fin;
  }

  Map _createDias(DateTime timestamp, DateTime timestamp2) {
    //Función que añade los días entre medias al MAP
    Map<dynamic, dynamic> dias = new Map();
    DateTime actual = timestamp;
    DateTime primerDatoDelUltimoDia = timestamp2.subtract(Duration(
        hours: timestamp2.hour,
        minutes: timestamp2.minute,
        seconds: timestamp2.second - 1));
    while (primerDatoDelUltimoDia.isAfter(actual)) {
      dias[_getDate(actual)] = new List<DataElement>();
      actual = actual.add(Duration(days: 1));
    }
    dias[_getDate(actual)] = new List<DataElement>();

    return dias;
  }
}
