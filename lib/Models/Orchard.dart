import 'package:firebase_database/firebase_database.dart';

class Orchard {
  String key;
  String Name;
  List<dynamic> Temp;
  List<dynamic> HumiditySup;
  List<dynamic> HumidityInf;
  List<dynamic> CO2;
  Map<dynamic, dynamic> alerts;
  Map<dynamic, dynamic> plots;
  String Vegetable;
  String City;
  String img;

  Orchard(this.Name, this.Temp, this.Vegetable, this.City);

  Orchard.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        alerts = snapshot.value["Alerts"],
        Name = snapshot.key,
        img = snapshot.value["Img"],
        Temp = snapshot.value["Temperature"],
        Vegetable = snapshot.value["Vegetable"],
        HumiditySup = snapshot.value["Humidity30"],
        HumidityInf = snapshot.value["Humidity40"],
        CO2 = snapshot.value["CO2"],
        City = snapshot.value["City"],
        plots = snapshot.value["sensorData"];

  toJson() {
    return {
      "Name": Name,
      "key": key,
      "temperature": Temp,
      "Ciy": City,
    };
  }
}
