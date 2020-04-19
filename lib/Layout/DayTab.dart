import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Structure/DataElement.dart';
import 'package:esgarden/Structure/Plot.dart';
import 'package:esgarden/UI/LineChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'FormVisualization.dart';

class DayTab extends StatefulWidget {

  List<DataElement> data;
  int day;
  Plot PlotKey;
  String type;
  Color color;
  DayTab({Key key, this.data, this.day, this.PlotKey, this.type, this.color}) : super(key: key);

  DayTabState createState() {

    return DayTabState();
  }
}
class DayTabState extends State<DayTab>{
  DateTime _time;
  Map<String, num> _measures;

  @override
  Widget build(BuildContext context){
    String days;
    switch (widget.day) {
      case 0:
        days = "Today";
        break;
      case 1:
        days = "Yesterday";
        break;
      default:
        days = widget.day.toString() + " days ago";
        break;
    }

    var maxValueTop = _getHighestValue(widget.data,true);
    var minValueTop = _getLowestValue(widget.data, maxValueTop,true);

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
                              days,
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
                        color: widget.color,
                        elevation: 4.0,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0, bottom: 8.0),
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
                                        maxValueTop.toString() + MEASURING_UNITS[widget.type],
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
                                        minValueTop.toString() + MEASURING_UNITS[widget.type],
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
                    padding: const EdgeInsets.only(left: 16.0, top: 50),
                    child: Container(
                      height: 320,
                      width: 290,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: LineChart.createData(widget.color, widget.data, widget.type, 100, selectionModelConfig())),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 50),
                    child: Container(
                      height: 100,
                      width: 290,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            children: <Widget>[

                              Center(child: Text(_time.toString(),style: TextStyle(fontSize: 20.0, color: Colors.lightGreen),)),


                            ],
                          )
                      ),
                    ),
                  )
                  //_createNotificationTab(notifications),
                ],
              ),
            ),
          ),
        ));
  }

  charts.SelectionModelConfig<DateTime> selectionModelConfig(){
    return  new charts.SelectionModelConfig(
      type: charts.SelectionModelType.info,
      changedListener: _onSelectionChanged,
    );
  }


  _onSelectionChanged(charts.SelectionModel model) {

    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        print(datumPair.datum.toString());
        //measures[datumPair.series.displayName] = datumPair.datum.item;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
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
      if(!first){
        pos = value.length-1;
      }
      if(value != null) {
        if(value[pos]> highest){
          highest = value[pos];
        }

      }
    }


    return highest;
  }
  int _getLowestValue( List data, var val, bool first) {
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
      if(!first){
        pos = value.length-1;
      }
      if(value != null) {
        if(value[pos]< lowest){
          lowest = value[pos];
        }

      }
    }


    return lowest;
  }

  bool doubleData(){

   if(VALUE_RELATION[widget.type] != null){
     return true;
   }
   return false;
  }
  Widget _ifDoubleData(String s) {
    //Si hay que interpretar más de un valor en la tabla

    if(doubleData()) {
      return Text(s, style: TextStyle(fontSize: 20.0, color: Colors.white),);
    }
    else return Text( CATALOG_NAMES[CATALOG_TYPES[widget.type]], style: TextStyle(fontSize: 20.0, color: Colors.white),);
  }

  Widget SecondLimit() {
    if(doubleData()){
      var maxValueBottom = _getHighestValue(widget.data,false);
      var minValueBottom = _getLowestValue(widget.data, maxValueBottom,false);
      return Padding(
        padding: const EdgeInsets.only(
            top: 15, left: 30, right: 30, bottom: 15),
        child: Container(
          width: 300,
          child: Material(
            color: widget.color,
            elevation: 4.0,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0, bottom: 8.0),
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
                            style: TextStyle(
                                fontSize: 26, color: Colors.white),
                          ),
                          Text(
                            maxValueBottom.toString() + MEASURING_UNITS[widget.type],
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
                            minValueBottom.toString() + MEASURING_UNITS[widget.type],
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
      );
    }
    return Center();

  }
}
