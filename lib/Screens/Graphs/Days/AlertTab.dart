import 'package:esgarden/Models/Alert.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:esgarden/Services/Alerts.dart';
import 'package:esgarden/Services/AlertsCheck.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AlertsTab extends StatefulWidget {
  Plot PlotKey;
  String type;

  AlertsTab({this.PlotKey, this.type});

  @override
  _AlertsTabState createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  Alerts alertsService;
  AlertsCheck alertsCheckService;
  final _database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    alertsService = new Alerts(PlotKey: widget.PlotKey, type: widget.type);
    alertsCheckService =
        new AlertsCheck(type: widget.type, PlotKey: widget.PlotKey);
  }

  Widget build(BuildContext context,) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Card(
          child: FutureBuilder(
            future: alertsCheckService.Check(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return FutureBuilder(

                  future: alertsService.getAlertsList(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      print(snapshot.data);
                      return Column(
                        children: <Widget>[
                          Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15,
                                        bottom: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(Icons.notifications),
                                        ),
                                        Text(
                                          "Alerts List",
                                          style: TextStyle(fontSize: 20.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 200,
                                    child: ListView(children: _createChildren(
                                        context, snapshot.data)),
                                  )
                                ],
                              ))
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator(),);
                  },
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },
          )),
    );
  }

  List<Widget> _createChildren(BuildContext context, List<dynamic> alerts) {
    Alert a = new Alert.fromAlert(type: AlertType.Warning, value: "Hola");
    List<Widget> res = [];
    //Si no hay elementos de alerta, muestra el default
    if (alerts.length <= 1) {
      for (var i = 0; i < alerts.length; i++) {
        Widget not = createNotification(alerts[i]);
        res.add(not);
      }
    } else {
      for (var i = 0; i < alerts.length; i++) {
        Widget not = createNotification(alerts[i]);
        res.add(not);
      }
    }


    return res;
  }

  Widget createNotificationElement(Alert alert) {
    print(alert);
    return ListTile(
      title: Text(alert.value),
      leading: Icon(alert.icon),
    );
  }

  Widget createNotification(Alert a) {
    return ListTile(
      title: Text(a.value),
      leading: Icon(a.icon),
    );
  }


}
