import 'package:esgarden/Models/Alert.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//SERVICIO ENCARGADO DE GENERAR ALERTAS

class Alerts {
  String type;
  Plot PlotKey;
  List<Alert> alerts =
      []; //Lo rellenamos en local, posteriormente será de la BD
  Alerts({@required this.PlotKey, this.type}) {
    _ChargeAlerts();
  }

  final _database = FirebaseDatabase.instance.reference();

  /**********************
      1. Primero realiza la búsqueda de las alertas en el plot. Si no existen, crea el elemento "No notifications"
      2. Después extrae las alertas y las devuelve en texto
   *********************/
  Future<bool> _CreateIfNotExists() async {
    final databaseReference = _database.child("Gardens");
    final databaseOrchard = databaseReference.child(PlotKey.parent);
    final databasePlots = databaseOrchard.child("sensorData");
    final databasePlot = databasePlots.child(PlotKey.key).child("Alerts");
    await databasePlot.once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> values = snapshot.value;
      bool found = false;
      values.forEach((key, values) {
        if (key == type) {
          found = true;
        }
      });
      if (!found) await _Create("No notifications");
    });
    return false;
  }

  Future<void> _Create(String notification) async {
    final databaseReference = _database.child("Gardens");
    final databaseOrchard = databaseReference.child(PlotKey.parent);
    final databasePlots = databaseOrchard.child("sensorData");
    final databasePlot = databasePlots.child(PlotKey.key);
    var set = await databasePlot.child("Alerts").update({
      type: [notification]
    });
  }

  //Esta función devuelve las reglas ya actualizadas
  Future<List<dynamic>> getAlertsList() async {
    await _CreateIfNotExists();
    final databaseReference = _database.child("Gardens");
    final databaseOrchard = databaseReference.child(PlotKey.parent);
    final databasePlots = databaseOrchard.child("sensorData");
    final databasePlot =
        databasePlots.child(PlotKey.key).child("Alerts").child(type);
    DataSnapshot dta = await databasePlot.once();
    List<Alert> ret = _fromTextToAlert(dta.value);
    // await  Future.delayed(Duration(seconds: 5));
    return ret;
  }

  /***********************/

  void _ChargeAlerts() {
    alerts.clear();
    alerts.add(new Alert.fromAlert(
        type: AlertType.LowerLimit, value: "Humidity is very low"));
    alerts.add(new Alert.fromAlert(
        type: AlertType.UpperLimit, value: "Humidity is very high"));
    alerts.add(
        new Alert.fromAlert(type: AlertType.Warning, value: "Humidity is low"));
    alerts.add(new Alert.fromAlert(
        type: AlertType.Information, value: "Check the humidity sensor"));
    alerts.add(new Alert.fromAlert(
        type: AlertType.Restriction, value: "Check the humidity below 60%"));
  }

  List<Alert> _fromTextToAlert(List alertsrec) {
    List<Alert> formattedAlerts = [];
    for (var j = 0; j < alertsrec.length; j++) {
      for (var i = 0; i < alerts.length; i++) {
        if (alerts[i].value == alertsrec[j]) {
          formattedAlerts.add(alerts[i]);
        }
      }
    }
    return formattedAlerts;
  }
}
