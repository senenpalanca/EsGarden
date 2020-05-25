import 'package:esgarden/Layout/DayTab.dart';
import 'package:esgarden/Layout/FormVisualization.dart';
import 'package:esgarden/Structure/DataElement.dart';
import 'package:esgarden/Structure/Plot.dart';
import 'package:esgarden/UI/LineChart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../Library/Globals.dart';
import '../UI/NotificationList.dart';


class formChart extends StatefulWidget {
  Plot PlotKey;
  Color color;
  String type;
  DateTime _time;
  Map<String, num> _measures;
  bool firstTime = true;
  formChart({Key key, @required this.PlotKey, this.color, this.type}) : super(key: key);

  @override
  formChartState createState() {

    return formChartState();
  }


}

class formChartState  extends State<formChart> {

  List<DataElement> data = new List<DataElement>();
  //Visualización

  List<Widget> tabs = [];
  Color colorAccent = Colors.redAccent;
  final PageController ctrl = PageController();
  final FirebaseDatabase _database = FirebaseDatabase.instance;



  Future<String> waitToLastPage() async {
    return new Future.delayed(Duration(milliseconds: 1000), () => "1");
  }

  @override
  Widget build(BuildContext context) {

    HandleData();
    print("************* DEBUG **************");
    print(" CATALOG_TYPE >  " + CATALOG_TYPES[widget.type]);
    print(" CATALOG_NAME >  " + CATALOG_NAMES[CATALOG_TYPES[widget.type]]);

    return Scaffold(
        appBar: AppBar(
          title:
              Text(CATALOG_NAMES[CATALOG_TYPES[widget.type]] + " of " + widget.PlotKey.Name),
          backgroundColor: widget.color,
        ),
        body: FormUI(),
    );
  }
  Widget FormUI() {
    if (widget.firstTime) {

      widget.firstTime = false;
      return FutureBuilder(
          future: waitToLastPage(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              List<Widget> buf = _createTabs(context);
              tabs = buf;
              ctrl.jumpToPage(buf.length - 2);
              return PageView(
                scrollDirection: Axis.horizontal,
                controller: ctrl,
                children: buf,
              );
            }
            return PageView(
              scrollDirection: Axis.horizontal,
              controller: ctrl,
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
      );
    }

    ctrl.jumpToPage(tabs.length - 2);
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: ctrl,
      children: tabs,
    );
  }
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
      dias[firstDate] = new List<DataElement>();

      for (var index = 0; index < DataElements.length; index++) {
        String date =
            _getDate(DataElements[index].timestamp.add(new Duration(hours: 1)));

        if (date == firstDate) {
          dias[date].add(DataElements[index]);
        } else {
          dias[date] = new List<DataElement>();
          dias[date].add(DataElements[index]);
          firstDate = date;
        }
      }
    }

    //Pasar el último valor de cada día
    List<Widget> fin = [];
    for (int i = 0; i < dias.length; i++) {
      Widget tab = new DayTab();
      fin.add(new DayTab(data: dias[dias.keys.toList()[i]], day: dias.length - (i + 1) ,color: widget.color,type: widget.type,PlotKey: widget.PlotKey,));
      /*fin.add(
          createGraph(
          context, dias[dias.keys.toList()[i]], dias.length - (i + 1)));*/
    }

    fin.add(NotificationList(widget.PlotKey.alerts["T1"]));

    return fin;
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
      widget._time = time;
      widget._measures = measures;
    });
  }



}
