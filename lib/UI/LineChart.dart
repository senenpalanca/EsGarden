import 'package:charts_flutter/flutter.dart' as charts;
import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Structure/DataElement.dart';
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  int highest;
  int lowest;

  LineChart(this.seriesList, this.highest, this.lowest, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory LineChart.createData(
      Color color, List data, String type, int maxValue) {
    return new LineChart(
      _createData(color, data, type),
      maxValue,
      0,
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList,
        defaultRenderer: new charts.LineRendererConfig(
            strokeWidthPx: 3,
            includeArea: true,
            stacked: false,
            //includePoints: true,
            includeLine: true),
        animate: false,
        behaviors: [
          new charts.PanAndZoomBehavior(),
          new charts.SlidingViewport(),
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
          showAxisLine: false,
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
          //viewport:  charts.NumericExtents(0,highest),
          renderSpec: new charts.GridlineRendererSpec(
              //minimumPaddingBetweenLabelsPx: 25,

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 13, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.transparent)),
        ),
        domainAxis: new charts.DateTimeAxisSpec(

            //HIDE Domain Axis:
            //  renderSpec: new charts.NoneRenderSpec(),
            renderSpec: charts.SmallTickRendererSpec(
                // Tick and Label styling here.
                minimumPaddingBetweenLabelsPx: 0,
                labelOffsetFromAxisPx: 20,
                lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.black.lighter),
                labelStyle: new charts.TextStyleSpec(
                  color: charts.MaterialPalette.black.lighter,
                )),
            //tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
            //tickProviderSpec: charts.AutoDateTimeTickProviderSpec(includeTime: true),
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                // day: new charts.TimeFormatterSpec(format: 'MMM d'),
                hour: new charts.TimeFormatterSpec(
                    format: 'hh:mm', transitionFormat: 'MMM d HH:mm')))

        /// Assign a custom style for the measure axis.

        );
  }

  /// Create one series with sample hard coded data.

  static List<charts.Series<TimeSeriesValue, DateTime>> _createData(
    Color color,
    List<DataElement> data,
    String type,
  ) {
    List<DataElement> DataElements = new List<DataElement>.from(data);

    DataElements.removeWhere((value) => value == null);

    final List<TimeSeriesValue> dataList = [];
    Map<int, List<TimeSeriesValue>> dataLists = {};
    int numeroDeValores = 1;
    if (VALUE_RELATION[type] != null) {
      numeroDeValores = VALUE_RELATION[type].length;
    }
    for (var n = 0; n < numeroDeValores; n++) {
      //Inicializa las listas
      dataLists[n] = [];
    }
    for (var i = 0; i < DataElements.length; i++) {

      var typeNo = int.parse(CATALOG_TYPES[type.toLowerCase()]);

      List value = DataElements[i].Values[typeNo];
      if(value != null) {
        for (var j = 0; j < value.length; j++) {
          if (DataElements[i].Types.contains(typeNo)) {
            //Comprobación Innecesaria, se ha hecho en FormChart
            if (value[j] != null) {
              dataLists[j].add(new TimeSeriesValue(DataElements[i].timestamp,
                  value[j] /* DataElements[i].Fields[j]*/));
            } else {
              dataLists[j].add(new TimeSeriesValue(
                  DataElements[i].timestamp, 0 /* DataElements[i].Fields[j]*/));
            }
          }
        }
      }
    }
    return _createSeries(dataLists, color);
    /*
    return [
      new charts.Series<TimeSeriesValue, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha),
        areaColorFn: (_, __) => charts.Color(
                r: color.red, g: color.green, b: color.blue, a: color.alpha)
            .lighter
            .lighter,
        domainFn: (TimeSeriesValue item, _) => item.time,
        measureFn: (TimeSeriesValue item, _) => item.value,
        data: dataList,
      )
    ];*/
  }


  static List<charts.Series<TimeSeriesValue, DateTime>> _createSeries(Map<int, List<TimeSeriesValue>> dataLists, Color color) {

    List<charts.Series<TimeSeriesValue, DateTime>> ret = [];
    List<Color> colors = [color];
    if(dataLists.keys.length>1) {
      if (color == Colors.blue) { //IF COME FROM BLUE COLOR

        colors = [
          Colors.cyanAccent,
          Colors.lightBlueAccent,
          Colors.blueAccent,
          Colors.indigo
        ];
      } else if (color == Colors.red) {
        colors = [ //PREDET. COLORS
          Colors.green,
          Colors.yellowAccent,
          Colors.orange,
          Colors.redAccent,
        ];
      }
    }

    //List<charts.MaterialPalette> colors = [charts.MaterialPalette.blue.shadeDefault,charts.MaterialPalette.cyan.shadeDefault.darker ];
    for (int i = 0; i < dataLists.keys.length; i++) {
      ret.add(new charts.Series<TimeSeriesValue, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(colors[i]).darker,
        areaColorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(colors[i]).lighter,
        //charts.MaterialPalette.cyan.shadeDefault.lighter,
        domainFn: (TimeSeriesValue item, _) => item.time,
        measureFn: (TimeSeriesValue item, _) => item.value,
        data: dataLists[i],
      ));
    }
    return ret;
  }

  static List _actualize(List values) {
    List ret =
        values.toList(); //el primer valor del array de firebase es el superior

    return ret; //ret.reversed.toList();
  }

  static List _actualizeOld(List values) {
    List ret =
        values.toList(); //el primer valor del array de firebase es el superior
    List fin = [];
    for (int i = 0; i < ret.length - 1; i++) {
      ret[i] = ret[i] - ret[i + 1];
    }

    return ret.reversed.toList();
  }
}

/// Sample linear data type.
class DataItem {
  final int no;
  final int value;

  DataItem(this.no, this.value);
}

class TimeSeriesValue {
  final DateTime time;
  final int value;

  TimeSeriesValue(this.time, this.value);
}
