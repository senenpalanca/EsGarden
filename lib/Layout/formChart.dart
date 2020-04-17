import 'package:esgarden/Layout/FormVisualization.dart';
import 'package:esgarden/Structure/DataElement.dart';
import 'package:esgarden/Structure/Plot.dart';
import 'package:esgarden/UI/LineChart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Library/Globals.dart';
import '../UI/NotificationList.dart';

class formChart extends StatelessWidget {
  Plot PlotKey;
  List<DataElement> data = new List<DataElement>();

  Color color;
  String type;
  Color colorAccent = Colors.redAccent;
  final PageController ctrl = PageController();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  formChart({Key key, @required this.PlotKey, this.type, this.color})
      : super(key: key);

  Future<String> waitToLastPage() async {
    return new Future.delayed(Duration(milliseconds: 2000), () => "1");
  }

  @override
  Widget build(BuildContext context) {
    HandleData();
    print("************* DEBUG **************");
    print(" CATALOG_TYPE >  " + CATALOG_TYPES[type]);
    print(" CATALOG_NAME >  " + CATALOG_NAMES[CATALOG_TYPES[type]]);

    return Scaffold(
        appBar: AppBar(
          title:
              Text(CATALOG_NAMES[CATALOG_TYPES[type]] + " of " + PlotKey.Name),
          backgroundColor: color,
        ),
        body: FutureBuilder(
            future: waitToLastPage(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                List<Widget> buf = _createTabs(context);
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
            }));
  }

  HandleData() {
    data.clear();
    _database
        .reference()
        .child("usuarios")
        .child(PlotKey.parent)
        .child("sensorData")
        .child(PlotKey.key)
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
      int p = int.parse(CATALOG_TYPES[type.toLowerCase()]);
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
      fin.add(createGraph(
          context, dias[dias.keys.toList()[i]], dias.length - (i + 1)));
    }

    fin.add(NotificationList(PlotKey.alerts["T1"]));

    return fin;
  }

  Widget createGraph(
    BuildContext context,
    List<DataElement> data,
    int day,
  ) {
    String days;
    switch (day) {
      case 0:
        days = "Today";
        break;
      case 1:
        days = "Yesterday";
        break;
      default:
        days = day.toString() + " days ago";
        break;
    }

    int maxValue = _getHighestValue(data);
    int minValue = _getLowestValue(data, maxValue);

    return Container(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => formVisualization(
                      PlotKey: PlotKey,
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
                      CATALOG_NAMES[CATALOG_TYPES[type]] +
                          " (" +
                          MEASURING_UNITS[type] +
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
                    color: color,
                    elevation: 4.0,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                                maxValue.toString() + MEASURING_UNITS[type],
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
                                minValue.toString() + MEASURING_UNITS[type],
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 50),
                child: Container(
                  height: 320,
                  width: 290,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: LineChart.createData(color, data, type, 100)),
                ),
              ),

              //_createNotificationTab(notifications),
            ],
          ),
        ),
      ),
    ));
  }

  int _getLowestValue(List data, int maxValue) {
    List DataElements = data;
    DataElements.removeWhere((value) => value == null);
    final List<int> dataList = [];

    for (var i = 0; i < DataElements.length; i++) {
      int j = DataElements[i].Types.indexOf(CATALOG_TYPES[type.toLowerCase()]);
      if (j != -1) {
        dataList.add(DataElements[i].Fields[j]);
      }
    }

    int lowest = maxValue;
    for (var i = 0; i < dataList.length; i++) {
      if (dataList[i] < lowest) {
        lowest = dataList[i];
      }
    }
    return lowest;
  }

  int _getHighestValue(List data) {
    List DataElements = data;
    DataElements.removeWhere((value) => value == null);
    final List<int> dataList = [];

    for (var i = 0; i < DataElements.length; i++) {
      int j = DataElements[i].Types.indexOf(CATALOG_TYPES[type.toLowerCase()]);

      if (j != -1) {
        dataList.add(DataElements[i].Fields[j]);
      }
    }

    int highest = 0;
    for (var i = 0; i < dataList.length; i++) {
      if (dataList[i] > highest) {
        highest = dataList[i];
      }
    }

    return highest;
  }
}
