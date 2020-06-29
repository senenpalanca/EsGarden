import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AlertType {
  Warning,
  Information,
  Restriction,
  LowerLimit,
  UpperLimit,
  NoAlert,
}

enum ValueLogic { Equal, NonEqual, Bigger, Smaller }

class Alert {
  String key;
  AlertType type;
  String value;
  IconData icon;
  ValueLogic operator;
  double condition;

  Alert(
      {this.type,
      this.value,
      this.icon = Icons.all_inclusive,
      this.operator,
      this.condition});

  Alert.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        //type = snapshot.value["Type"],
        value = snapshot.value["Value"],
        //icon = snapshot.value["Icon"],
        operator = snapshot.value["Operator"],
        condition = snapshot.value["Condition"];

  toJson() {
    return {
      "Type": type.toString(),
      "Value": value,
      "Icon": icon.hashCode,
      "Operator": operator,
      "Condition": condition
    };
  }

  Alert.fromAlert({this.type, this.value}) {
    switch (this.type) {
      case AlertType.Warning:
        this.icon = Icons.warning;
        break;
      case AlertType.Information:
        this.icon = Icons.info;
        break;
      case AlertType.Restriction:
        this.icon = Icons.clear;
        break;
      case AlertType.UpperLimit:
        this.icon = Icons.arrow_upward;
        break;
      case AlertType.LowerLimit:
        this.icon = Icons.arrow_downward;
        break;
      default:
        this.icon = Icons.warning;
    }
  }
}
