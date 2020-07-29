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

class Plot {
  String key;
  String Name;
  List<dynamic> Temp;
  List<dynamic> HumiditySup;
  List<dynamic> HumidityInf;
  List<dynamic> CO2;
  List<dynamic> items;

  //dynamic alerts;
  Map<dynamic, dynamic> data;
  String Vegetable;
  String City;
  String img;
  String parent;
  String vegetableIndex;

  Plot(this.Name, this.Temp, this.Vegetable, this.City);

  Plot.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
  //alerts = snapshot.value["Alerts"],
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
      //"Alerts": alerts,
      "Parent": parent
    };
  }
}
