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

class DataElement {
  String key;
  dynamic DataSlot;
  Map<dynamic, dynamic> Values = new Map();
  int val = -1;

  //List Fields;
  List Types;

  DateTime timestamp;

  DataElement(this.DataSlot, this.timestamp);

  DataElement.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        Types = _getTypes(snapshot),
        Values = _getValues(snapshot),
        timestamp = DateTime.fromMillisecondsSinceEpoch(
          snapshot.value["timestamp"],
          isUtc: true,
        );

  toJson() {
    return {
      "key": key,
      "timestamp": timestamp.toString(),
    };
  }

  static List _createFields(DataSnapshot snapshot) {
    List fields = [];
    for (int i = 1; i < 5; i++) {
      fields.add(snapshot.value["F" + i.toString()]);
    }
    return fields;
  }

  static List _createTypes(DataSnapshot snapshot) {
    List fields = [];
    for (int i = 1; i < 5; i++) {
      fields.add(snapshot.value["T" + i.toString()]);
    }
    return fields;
  }

  static _getTypes(DataSnapshot snapshot) {
    Map<dynamic, dynamic> Dataslot = {};
    List types = [];
    for (int i = 0; i < 5; i++) {
      Dataslot = snapshot.value["DATASLOT_" + i.toString()];
      if (Dataslot != null) {
        types.add(Dataslot["Type"]);
      }
    }
    return types;
  }

  static _getValues(DataSnapshot snapshot) {
    Map<dynamic, dynamic> Dataslot = {};
    Map<dynamic, dynamic> values = {};
    for (int i = 0; i < 5; i++) {
      Dataslot = snapshot.value["DATASLOT_" + i.toString()];
      if (Dataslot != null) {
        values[Dataslot["Type"]] = Dataslot["Value"];
      }
    }
    return values;
  }
}
