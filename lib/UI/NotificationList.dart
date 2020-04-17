import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  List alerts;

  NotificationList(this.alerts);

  @override
  Widget build(
    BuildContext context,
  ) {
    //key = catalogItem.Key;
    List tmp = alerts;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Card(
          child: Column(
        children: <Widget>[
          Container(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.notifications),
                    ),
                    Text(
                      "Notifications List",
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
                child: ListView(children: _createChildren(context, alerts)),
              )
            ],
          )),
        ],
      )),
    );
  }

  List<Widget> _createChildren(BuildContext context, List alerts) {
    List res = [];
    //Si no hay elementos de alerta, muestra el default
    if (alerts.length <= 1) {
      res = alerts
          .map<Widget>((data) => createNotificationElement(context, data))
          .toList();
    } else {
      alerts = alerts.sublist(1);
      print(alerts);
      res = alerts
          .map<Widget>((data) => createNotificationElement(context, data))
          .toList();
    }
    return res;
  }

  Widget createNotificationElement(BuildContext context, String text) {
    return ListTile(
      title: Text(text),
      leading: Icon(Icons.warning),
    );
  }
}
