import 'package:esgarden/Library/Globals.dart' as globals;
import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Models/DataElement.dart';
import 'package:esgarden/UI/Chip.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SimpleGraph extends StatefulWidget {
  List<DataElement> data;
  Color color;
  String type;

  SimpleGraph({this.data, this.color, this.type});

  @override
  _SimpleGraphState createState() => _SimpleGraphState();
}

class _SimpleGraphState extends State<SimpleGraph> {
  ZoomPanBehavior zooming;
  SfCartesianChart chart;
  String ItemTypeTrend;

  Trendline selectedTrend;

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
        zoomPanBehavior: zooming,
        primaryXAxis: DateTimeAxis(
          //majorGridLines: MajorG,
          interval: 2,
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
    ItemTypeTrend = typeTrends[0];

    return Container(
      //height: 300,
      //height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(child: Text('Zoom Out'), onPressed: zoom),
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

  List<AreaSeries<DataElement, DateTime>> _createSeries() {
    List<AreaSeries<DataElement, DateTime>> returnList = new List();
    int noOfValues = VALUE_RELATION[widget.type] == null
        ? 1
        : VALUE_RELATION[widget.type].length;

    bool _checkSerieNotNull(int i) {
      widget.data.forEach((DataElement e) {
        if (e.Values[[double.parse(CATALOG_TYPES[widget.type])][0]] == null) {
          return false;
        }
      });
      return true;
    }

    for (var i = 0; i < noOfValues; i++) {
      if (_checkSerieNotNull(i)) {
        returnList.add(
          AreaSeries<DataElement, DateTime>(
              /*trendlines: ItemTypeTrend == typeTrends[0] ? null : <Trendline>[
                Trendline(
                    type: _selectTypeTrend(),
                    color: Colors.blue)
              ],*/
              name: VALUE_RELATION[widget.type] == null
                  ? CATALOG_NAMES[CATALOG_TYPES[widget.type]]
                  : VALUE_RELATION[widget.type][i],
              borderColor: noOfValues == 1 ? widget.color : colors[i],
              borderWidth: 3,
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
                  elm.Values[double.parse(CATALOG_TYPES[widget.type])][i]),
        );
      }
    }

    return returnList;
  }

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
                          onSelectionChanged: _createTrendLine,
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

  _selectTypeTrend() {
    //Convierte selección a ajuste de widget
    switch (ItemTypeTrend) {
      case "RAW Data":
        return TrendlineType.movingAverage;
        break;
      case "Smooth Data":
        return TrendlineType.polynomial;
        break;
      case "Logarithmic":
        return TrendlineType.logarithmic;
        break;
      case "Nothing":
        return null;
        break;
    }
  }

  _createTrendLine(String chipCaption) {
    setState(() {
      print(chipCaption);
      ItemTypeTrend = chipCaption;
    });
  }
}
