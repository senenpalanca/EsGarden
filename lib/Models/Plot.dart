import 'package:firebase_database/firebase_database.dart';

class Plot {
  String key;
  String Name;
  List<dynamic> Temp;
  List<dynamic> HumiditySup;
  List<dynamic> HumidityInf;
  List<dynamic> CO2;
  List<dynamic> items;
  Map<dynamic, dynamic> alerts;
  Map<dynamic, dynamic> data;
  String Vegetable;
  String City;
  String img;
  String parent;
  String vegetableIndex;

  Plot(this.Name, this.Temp, this.Vegetable, this.City);

  Plot.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        alerts = snapshot.value["Alerts"],
        data = snapshot.value["Data"],
        Name = snapshot.value["Name"],
        img = snapshot.value["Img"],
        Temp = snapshot.value["Temperature"],
        Vegetable = snapshot.value["Vegetable"],
        HumiditySup = snapshot.value["Humidity30"],
        HumidityInf = snapshot.value["Humidity40"],
        CO2 = snapshot.value["CO2"],
        items = snapshot.value["Items"],
        parent = snapshot.value["Parent"],
        vegetableIndex = snapshot.value["VegetableIndex"],
        City = snapshot.value["City"];

  toJson() {
    return {
      "Name": Name,
      "key": key,
      "temperature": Temp,
      "CO2": CO2,
      "Humidity30": HumiditySup,
      "Humidity40": HumidityInf,
      "Alerts": alerts
    };
  }
}
