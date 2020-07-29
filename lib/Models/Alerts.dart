/*
 * // Copyright <2020> <Universitat Politència de València>
 * // Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * // software and associated documentation files (the "Software"), to deal in the Software
 * // without restriction, including without limitation the rights to use, copy, modify, merge,
 * // publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
 * // to whom the Software is furnished to do so, subject to the following conditions:
 * //
 * //The above copyright notice and this permission notice shall be included in all copies or
 * // substantial portions of the Software.
 * // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * // EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * // OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * // AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * // THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * //
 * // This version was built by senenpalanca@gmail.com in ${DATE}
 * // Updates available in github/senenpalanca/esgarden
 * //
 * //
 */

import 'package:firebase_database/firebase_database.dart';

const List<String> typeSeries = ["<=", ">="];

class AlertStamp {
  String key;
  String type;
  int value;
  int field;
  DateTime timestamp;
  String condition;

  AlertStamp({this.type,
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
