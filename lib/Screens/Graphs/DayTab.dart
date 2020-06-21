import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Screens/Graphs/SimpleGraph.dart';
import 'package:esgarden/UI/LineChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'DetailedDayTab.dart';

class DayTab extends StatefulWidget {
  List<DataElement> data;
  int day;
  Plot PlotKey;
  String type;
  Color color;
  String dayText;

  DayTab(
      {Key key,
      this.data,
      this.day,
      this.PlotKey,
      this.type,
      this.color,
      this.dayText})
      : super(key: key);

  DayTabState createState() {
    return DayTabState();
  }
}

class DayTabState extends State<DayTab> {
  @override
  Widget build(BuildContext context) {
    var maxValueTop = _getHighestValue(widget.data, true);
    var minValueTop = _getLowestValue(widget.data, maxValueTop, true);

    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => formVisualization(
                      PlotKey: widget.PlotKey,
                      color: widget.color,
                      type: widget.type,
                      data: widget.data,
                    )),
          );
        },
        child: Card(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      CATALOG_NAMES[CATALOG_TYPES[widget.type]] +
                          " (" +
                          MEASURING_UNITS[widget.type] +
                          " ) " +
                          widget.dayText,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 30, right: 30, bottom: 15),
                child: Container(
                  width: 300,
                  child: Material(
                    color: doubleData() ? colors[0] : widget.color,
                    elevation: 4.0,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Column(
                        children: <Widget>[
                          _ifDoubleData("upper"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "MAX",
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.white),
                                  ),
                                  Text(
                                    maxValueTop.toString() +
                                        MEASURING_UNITS[widget.type],
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "MIN",
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.white),
                                  ),
                                  Text(
                                    minValueTop.toString() +
                                        MEASURING_UNITS[widget.type],
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SecondLimit(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 50),
                child: Container(
                    height: 350,
                    width: 290,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: SimpleGraph(
                          color: widget.color,
                          data: widget.data,
                          type: widget.type,
                        ) //LineChart.createData( widget.color,widget.data,widget.type,100,selectionModelConfig())
                        ) //LineChart(widget.color, widget.data, widget.type, 100, selectionModelConfig())),
                    ),
              ),

              //_createNotificationTab(notifications),
            ],
          ),
        ),
      ),
    ));
  }

  int _getHighestValue(List data, bool first) {
    int highest = 0;
    int pos = 0;
    List<DataElement> DataElements = data;
    Map<int, List<TimeSeriesValue>> dataLists = {};
    DataElements.removeWhere((value) => value == null);
    int numeroDeValores = 1;
    if (VALUE_RELATION[widget.type] != null) {
      numeroDeValores = VALUE_RELATION[widget.type].length;
    }
    for (var n = 0; n < numeroDeValores; n++) {
      //Inicializa las listas
      dataLists[n] = [];
    }

    for (var i = 0; i < DataElements.length; i++) {
      var typeNo = int.parse(CATALOG_TYPES[widget.type.toLowerCase()]);
      List value = DataElements[i].Values[typeNo];
      if (!first) {
        pos = value.length - 1;
      }
      if (value != null) {
        if (value[pos] > highest) {
          highest = value[pos];
        }
      }
    }

    return highest;
  }

  int _getLowestValue(List data, var val, bool first) {
    int lowest = val;
    int pos = 0;
    List<DataElement> DataElements = data;
    Map<int, List<TimeSeriesValue>> dataLists = {};
    DataElements.removeWhere((value) => value == null);
    int numeroDeValores = 1;
    if (VALUE_RELATION[widget.type] != null) {
      numeroDeValores = VALUE_RELATION[widget.type].length;
    }
    for (var n = 0; n < numeroDeValores; n++) {
      //Inicializa las listas
      dataLists[n] = [];
    }
    for (var i = 0; i < DataElements.length; i++) {
      var typeNo = int.parse(CATALOG_TYPES[widget.type.toLowerCase()]);
      List value = DataElements[i].Values[typeNo];
      if (!first) {
        pos = value.length - 1;
      }
      if (value != null) {
        if (value[pos] < lowest) {
          lowest = value[pos];
        }
      }
    }

    return lowest;
  }

  bool doubleData() {
    if (VALUE_RELATION[widget.type] != null) {
      return true;
    }
    return false;
  }

  Widget _ifDoubleData(String s) {
    //Si hay que interpretar más de un valor en la tabla
    if (doubleData()) {
      return Text(
        s,
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      );
    } else
      return Text(
        CATALOG_NAMES[CATALOG_TYPES[widget.type]],
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      );
  }

  Widget SecondLimit() {
    if (doubleData()) {
      var maxValueBottom = _getHighestValue(widget.data, false);
      var minValueBottom = _getLowestValue(widget.data, maxValueBottom, false);
      return Padding(
        padding:
            const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 15),
        child: Container(
          width: 300,
          child: Material(
            color: colors[3],
            //Es estático, es el último color de los colores, en globals
            elevation: 4.0,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                children: <Widget>[
                  _ifDoubleData("lower"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "MAX",
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                          Text(
                            maxValueBottom.toString() +
                                MEASURING_UNITS[widget.type],
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "MIN",
                            style: TextStyle(fontSize: 26, color: Colors.white),
                          ),
                          Text(
                            minValueBottom.toString() +
                                MEASURING_UNITS[widget.type],
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Center();
  }
}
