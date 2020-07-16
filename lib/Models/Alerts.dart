import 'package:firebase_database/firebase_database.dart';

const List<String> typeSeries = ["<=", ">="];

class AlertStamp {
  String key;
  String type;
  int value;
  int field;
  DateTime timestamp;
  String condition;

  AlertStamp(
      {this.type,
      this.value,
      this.timestamp,
      this.condition,
      this.field,
      this.key});

  AlertStamp.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        type = snapshot.value["Type"],
        field = snapshot.value["Field"],
        value = snapshot.value["Value"],
        condition = snapshot.value["Condition"],
        timestamp = DateTime.fromMicrosecondsSinceEpoch(1583842087);

  toJson() {
    return {
      "Type": type,
      "Value": value,
      "Field": field,
      "Condition": condition,
      "Timestamp": timestamp.millisecondsSinceEpoch,
    };
  }
}

class AlertModel {
  var type;
  String condition;
  int value;

  //String key;
  int field;

  AlertModel({this.type, this.value, this.field, this.condition});

  AlertModel.fromSnapshot(DataSnapshot snapshot)
      : // key = snapshot.key,
        type = snapshot.value["Type"],
        condition = snapshot.value["Condition"],
        field = snapshot.value["Field"],
        value = snapshot.value["Value"];

  toJson() {
    return {
      "Type": type,
      "Condition": condition,
      "Field": field,
      "Value": value,
    };
  }
}
