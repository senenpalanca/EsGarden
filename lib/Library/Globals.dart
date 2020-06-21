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
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
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
    "Humidity",
    "Temperature",
    "GeoLocalization",
    "Air Quality",
    "Brightness",
    "Wind"
  ],
  "Nursery": ["Brightness"],
  "Compost": [
    "Compost Humidity",
    "Air Quality",
    "Historic Data",
    "Compost Temperature",
    "Brightness"
  ],
  "Plot": ["Humidity", "Temperature"],
};
const List<String> typeTrends = [
  "Nothing",
  "Average",
  "Polynomic",
  "Logaritmic",
];

List<dynamic> colors = [
  //PREDET. COLORS
  Colors.green,
  Colors.yellowAccent,
  Colors.orange,
  Colors.redAccent,
];

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
