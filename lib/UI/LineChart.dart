import 'package:charts_flutter/flutter.dart' as charts;
import 'package:esgarden/Library/Globals.dart';
import 'package:esgarden/Structure/DataElement.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:charts_flutter/src/text_element.dart';
import 'dart:math';
/*
class LineCharts extends StatelessWidget{
  int highest;
  int lowest;
  Color color;
  List data;
  String type;
  bool animate;
  charts.SelectionModelConfig<DateTime> SelectionModelConfig = null;

  LineChart(this.data, this.highest, this.lowest, {this.animate});
  @override
  LineChartState createState() {
    // TODO: implement createState
    return LineChartState( _createData(color, data, this.type),this.highest,0, this.SelectionModelConfig, this.color);
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

}

*/
class LineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  int highest;
  int lowest;
  Color firstColor;
  DateTime time;
  final measures = <String, num>{};

  charts.SelectionModelConfig<DateTime> SelectionModelConfig = null;
  LineChart(this.seriesList, this.highest, this.lowest, this.SelectionModelConfig, this.firstColor, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.

  factory LineChart.createData( Color color, List data, String type, int maxValue, charts.SelectionModelConfig<DateTime> selectionModelConfig) {
        return new LineChart( _createData(color, data, type), maxValue, 0, selectionModelConfig, color,     );
  }
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
          Colors.green,
          Colors.yellowAccent,
          Colors.orange,
          Colors.redAccent,
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
        /*selectionModels: [
          SelectionModelConfig
        ],*/
        behaviors: [
          charts.LinePointHighlighter(
              symbolRenderer: CustomCircleSymbolRenderer(text: "hola")
          )
        ],
        selectionModels: [
          charts.SelectionModelConfig(
              changedListener: (charts.SelectionModel model) {
                final selectedDatum = model.selectedDatum;

                DateTime _time;
                final _measures = <String, num>{};

                // We get the model that updated with a list of [SeriesDatum] which is
                // simply a pair of series & datum.
                //
                // Walk the selection updating the measures map, storing off the sales and
                // series name for each selection point.
                if (selectedDatum.isNotEmpty) {
                  time = selectedDatum.first.datum.time;
                  selectedDatum.forEach((charts.SeriesDatum datumPair) {
                    measures[datumPair.series.displayName] = datumPair.datum.sales;
                  });
                }

                /* Request a build.
                setState(() {
                  time = _time;
                  measures = _measures;
                });
                */
                /*
                if(model.hasDatumSelection)
                  /*setState(() {
                    textSelected = (model.selectedSeries[0].measureFn(model.selectedDatum[0].index)).toString();
                  });*/
                  print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
                  }*/
              }
          )
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
class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  String text;


  CustomCircleSymbolRenderer(
      {String text}
      ) { this.text = text; }

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds, {List<int> dashPattern, charts.Color fillColor, charts.Color strokeColor, double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);
    canvas.drawRect(

        Rectangle(bounds.left - 50, bounds.top - 120, bounds.width + 100, bounds.height + 100),
        fill: charts.Color.black
    );
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement(text, style: textStyle),
        (bounds.left).round(),
        (bounds.top - 28).round()
    );
  }
}