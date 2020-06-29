import 'package:esgarden/Models/Alert.dart';
import 'package:esgarden/Models/Plot.dart';
import 'package:firebase_database/firebase_database.dart';

class AlertsCheck {
  //Servicio que compara los datos del plot destino con las alertas definidas. Si existe alguna coincidencia, lo inserta en ../Plot/Alerts.
  Plot PlotKey;
  String type;

  AlertsCheck({this.type, this.PlotKey});

  List<Alert> alerts = [];
  DatabaseReference AlertsRef;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<int> _GetAlerts() async {
    AlertsRef = _database.reference().child('Alerts');
    await AlertsRef.onChildAdded.listen(_addAlert);
    _createAlert(
        new Alert.fromAlert(value: "Humidity is low", type: AlertType.Warning));
    //_createAlert(new Alert(type: AlertType.Warning,value: "Humidity is low",condition: 30, operator: ValueLogic.Smaller));
  }

  Future<int> Check() async {
    await _GetAlerts();
    await Future.delayed(Duration(seconds: 1));
    return 1;
  }

  void _addAlert(Event event) {
    Alert n = Alert.fromSnapshot(event.snapshot);
    alerts.add(n);
  }

  void _createAlert(Alert a) {
    AlertsRef.push().set(a.toJson());
  }
}
