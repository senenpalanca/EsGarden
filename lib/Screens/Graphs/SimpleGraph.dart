import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/UI/Chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SimpleGraph extends StatefulWidget {
  List<DataElement> data;
  Color color;
  String type;
  bool showTitle;

  SimpleGraph({this.data, this.color, this.type, this.showTitle = false});

  @override
  _SimpleGraphState createState() => _SimpleGraphState();
}

class _SimpleGraphState extends State<SimpleGraph> {
  ZoomPanBehavior zooming;
  SfCartesianChart chart;
  String SeriesType;

  List<dynamic> colors;

  void zoom() {
    zooming.reset();
  }

  @override
  Widget build(BuildContext context) {
    colors = globals.colors;
    //Config por defecto
    zooming = ZoomPanBehavior(
        enableSelectionZooming: true,
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 1,
        selectionRectColor: Colors.grey);
    chart = SfCartesianChart(
        title: widget.showTitle
            ? ChartTitle(
                text: globals.CATALOG_NAMES[globals.CATALOG_TYPES[widget.type]],
                textStyle: ChartTextStyle(fontSize: 15))
            : null,
        zoomPanBehavior: zooming,
        primaryXAxis: DateTimeAxis(
          desiredIntervals: 4,
          dateFormat: DateFormat.Hm(),
          //enableAutoIntervalOnZooming: false,
          /*
          maximum: widget.data.length < 5 && widget.data.length > 0
              ? widget.data[0].timestamp.add(Duration(hours: 20))
              : null,*/
          //majorGridLines: MajorG,
          //interval: 2,
          //dateFormat: ,
          //labelPosition: ChartDataLabelPosition.inside,
          //tickPosition: TickPosition.inside,
          isVisible: true,
        ),
        primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}' + MEASURING_UNITS[widget.type],
        ),
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: MediaQuery.of(context).orientation == Orientation.portrait
                ? LegendPosition.bottom
                : LegendPosition.right),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: _createSeries());


    return Container(
      //height: 300,
      //height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(),
                  RaisedButton(
                    child: Text(
                      'Zoom Out',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    onPressed: zoom,
                    color: Colors.green,
                  ),
                ],
              ),
              FlatButton(
                  child: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: _showSettingsDialog),
            ],
          ),
          chart
        ],
      ),
    );
  }

  /*START Series*/
  List<XyDataSeries<DataElement, DateTime>> _createSeries() {
    List<XyDataSeries<DataElement, DateTime>> returnList = new List();
    int noOfValues = VALUE_RELATION[widget.type] == null
        ? 1
        : VALUE_RELATION[widget.type].length;

    bool _checkThereIsSeries() {
      bool ret = true;
      widget.data.forEach((DataElement e) {
        if (e.Values[double.parse(CATALOG_TYPES[widget.type])] == null) {
          ret = false;
        }
      });
      return ret;
    }

    bool _checkSerieNotNull(int i) {
      bool ret = true;
      widget.data.forEach((DataElement e) {
        if (e.Values.length < noOfValues) {
          return false;
        }
      });
      return ret;

    }

    if (_checkThereIsSeries()) {
      for (var i = 0; i < noOfValues; i++) {
        if (_checkSerieNotNull(i)) {
          returnList.add(
              _createOneSerie(i, noOfValues)
          );
        }
      }
    }

    return returnList;
  }

  XyDataSeries<DataElement, DateTime> _createOneSerie(int i, int noOfValues) {
    switch (SeriesType) {
      case "RAW Data":
        return LineSeries<DataElement, DateTime>(
            name: VALUE_RELATION[widget.type] == null
                ? CATALOG_NAMES[CATALOG_TYPES[widget.type]]
                : VALUE_RELATION[widget.type][i],
            //borderColor: noOfValues == 1 ? widget.color : colors[i],
            //borderWidth: 3,
            color: noOfValues == 1
                ? widget.color.withOpacity(0.9)
                : colors[i].withOpacity(0.9),
            dataSource: widget.data,
            markerSettings: MarkerSettings(
              isVisible: widget.data.length < 23 ? true : false,
            ),
            xValueMapper: (DataElement elm, _) =>
                elm.timestamp.subtract(new Duration(hours: 1)),
            yValueMapper: (DataElement elm, _) =>
            elm.Values[double.parse(CATALOG_TYPES[widget.type])][i]);
        break;
      default:
        return SplineSeries<DataElement, DateTime>(
            name: VALUE_RELATION[widget.type] == null
                ? CATALOG_NAMES[CATALOG_TYPES[widget.type]]
                : VALUE_RELATION[widget.type][i],
            //borderColor: noOfValues == 1 ? widget.color : colors[i],
            //borderWidth: 3,
            color: noOfValues == 1
                ? widget.color.withOpacity(0.9)
                : colors[i].withOpacity(0.9),
            dataSource: widget.data,
            markerSettings: MarkerSettings(
              isVisible: widget.data.length < 23 ? true : false,
            ),
            xValueMapper: (DataElement elm, _) => elm.timestamp.toUtc(),
            yValueMapper: (DataElement elm, _) =>
            elm.Values[double.parse(CATALOG_TYPES[widget.type])][i]
        );
        break;
    }
  }

  /*END Series*/

  _showSettingsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Center(child: Text("Settings")),
            content: Container(
              child: Container(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Choose Data type",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.green),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: OptionChips(
                          typeSeries: typeTrends,
                          onSelectionChanged: _changeSeriesType,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Change"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }


  _changeSeriesType(String chipCaption) {
    setState(() {
      print(chipCaption);
      SeriesType = chipCaption;
    });
  }


}
