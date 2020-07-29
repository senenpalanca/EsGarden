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

library globals;

import 'package:esgarden/Models/CatalogItem.dart';
import 'package:esgarden/Models/Orchard.dart';
import 'package:flutter/material.dart';

bool isLogged = false;
bool isAdmin = false;
int gardensNo = 0;

List<Orchard> orchards = new List();
List<CatalogItem> catalog = new List();
List months = [
  " Jan ",
  " Feb ",
  " Mar ",
  " Apr ",
  " May ",
  " Jun ",
  " Jul ",
  " Aug ",
  " Sep ",
  " Oct ",
  " Nov ",
  " Dec "
];

const Map<String, String> CATALOG_TYPES = const {
  "brightness": "00",
  "ambienttemperature": "01",
  "ambienthumidity": "02",
  "ph": "03",
  "relativenoise": "04",
  "co2": "05",
  "rainfall": "06",
  "wind": "07",
  "soiltemperature": "08",
  "soilhumidity": "09",
};

const Map<String, String> CATALOG_NAMES = const {
  //AMBIENTE2
  "00": "Brightness", //Luminosidad
  "01": "Temperature", //Temp ambiente
  "02": "Humidity", //Hum. ambiente
  "03": "PH", //PH
  "04": "Relative Noise", //Ruido relativo
  "05": "Air Quality", //Calidad del aire
  "06": "Rainfall", //Pluviometría
  "07": "Wind", //Viento
  //PLOTS
  "08": "Soil Temperature", // Temp suelo, hum suelo,
  "09": "Soil Humidity" // Temp suelo, hum suelo,
};

const Map<String, String> MEASURING_UNITS = const {
  "upperhumidity": "%",
  "lowerhumidity": "%",
  "co2": "PPM",
  "ph": "",
  "soiltemperature": "º C",
  "soilhumidity": "%",
  "brightness": "Lux",
  "wind": "Mph",
  "ambienttemperature": "º C",
  "ambienthumidity": "%",
  "relativenoise": " units"
};

const Map<String, List<String>> VALUE_RELATION = const {
  "soilhumidity": [
    "Upper Humidity",
    "Middle-Upper Humidity",
    "Middle-Lower Humidity",
    "Lower Humidity"
  ],
  "soiltemperature": [
    "Upper Temperature",
    "Middle-Upper Temperature",
    "Middle-Lower Temperature",
    "Lower Temperature"
  ],
  /*"wind": [
    "winddirection",
    "windforce"
  ],*/
};
const Map<String, List<String>> ITEMS_PLOTS = const {
  "General": [
    "ElectroValve",
    "Humidity",
    "Temperature",
    "Air Quality",
    "Brightness",
    "Wind"
  ],
  "Nursery": [
    "ElectroValve",
    "Brightness",
    "Air Quality",
    "Temperature",
    "Humidity"
  ],
  "Compost": [
    "ElectroValve",
    "Compost Humidity",
    "Air Quality",
    "Historic Data",
    "Compost Temperature",
    "Brightness"
  ],
  "plot 1": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
  "plot 2": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
  "plot 3": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
  "plot 4": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
  "plot 5": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
  "plot 6": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
  "plot 7": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
  "plot 8": ["ElectroValve", "Vegetable", "Soil Humidity", "Soil Temperature"],
};

const Map<String, List<String>> SENSOR_PLOTS = const {
  "General": [
    "ElectroValve",
    "Humidity",
    "Temperature",
    "Air Quality",
    "Brightness",
    "Wind"
  ],
  "Nursery": [
    "ElectroValve",
    "Brightness",
    "Air Quality",
    "Temperature",
    "Humidity"
  ],
  "Compost": [
    "ElectroValve",
    "Compost Humidity",
    "Air Quality",
    "Historic Data",
    "Compost Temperature",
    "Brightness"
  ],
  "plot 1": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
  "plot 2": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
  "plot 3": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
  "plot 4": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
  "plot 5": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
  "plot 6": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
  "plot 7": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
  "plot 8": ["ElectroValve", "Soil Humidity", "Soil Temperature"],
};

const List<String> typeTrends = [
  "RAW Data",
  "Polynomic Data"
];

List<dynamic> colors = [
  //PREDET. COLORS
  Colors.green,
  Colors.yellowAccent,
  Colors.orange,
  Colors.redAccent,
];

Map<String, Map> alerts = new Map();

/*
const Map<String, String> CATALOG_TYPES = const {
  "soilhumidity": "00",
  "upperhumidity": "01",
  "lowerhumidity": "02",
  "co2": "03",
  "rainfall": "04",
  "luminosity": "05",
  "ambienttemperature": "06",
  "relativenoise": "07",
  "ambienthumidity": "08",
};

const Map<String, String> CATALOG_NAMES_OLD = const {
  "00": "Soil Humidity",
  "01": "Upper Humidity",
  "02": "Lower Humidity",
  "03": "Air Quality",
  "04": "Soil Temperature",
  "05": "Luminosity",
  "06": "Ambient Temperature",
  "07": "Relative Noise",
  "08": "Ambient Humidity"
};
*/
